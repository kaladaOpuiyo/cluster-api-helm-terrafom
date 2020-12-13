#!/bin/bash

CLUSTER_NAME=test-us-west-2-${workspace}

export AWS_REGION=${region} # This is used to help encode your environment variables
export AWS_ACCESS_KEY_ID=${aws_access_key_id} # seems to read aws creds
export AWS_SECRET_ACCESS_KEY=${aws_secrets_access_key}
export AWS_SSH_KEY_NAME=${ssh_key_name}
export AWS_CONTROL_PLANE_MACHINE_TYPE=${aws_control_plane_machine_type}
export AWS_NODE_MACHINE_TYPE=${aws_node_machine_type}
export CONTROL_PLAN_MACHINE_COUNT=${control_plan_machine_count}
export WORKER_MACHINE_COUNT=${worker_machine_count}


# Check if clusterawsadm exist or bootstraping
if ! command -v clusterawsadm &> /dev/null || ${bootstrap_iam} = true
then
    curl -LJO https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/${CLUSTERAWSADM_VERSION}/clusterawsadm-${CLUSTERAWSADM_DISTRO}
    chmod +x ./clusterawsadm-${CLUSTERAWSADM_DISTRO}
    mv ./clusterawsadm-${CLUSTERAWSADM_DISTRO}  /usr/local/bin/clusterawsadm 
    clusterawsadm version

    # The clusterawsadm utility takes the credentials that you set as environment
    # variables and uses them to create a CloudFormation stack in your AWS account
    # with the correct IAM resources.
    # NOTE TO SELF: Run this in tf
    clusterawsadm bootstrap iam create-cloudformation-stack --config ./aws-cluster-init/templates/aws-bootstrap.yaml

    exit
fi

# Create the base64 encoded credentials using clusterawsadm.
# This command uses your environment variables and encodes
# them in a value to be stored in a Kubernetes Secret.
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
# AWSManagedControlPlane\
# Finally, initialize the management cluster + kubeadm,eks support, dont worry will fail if exist on control cluster
clusterctl init --infrastructure=aws --control-plane aws-eks,kubeadm --bootstrap aws-eks,kubeadm


# Generate base config
    if [ ${eks} = true ]
        then
            if [ ${self_managed} = true ]
                then

                clusterctl config cluster $CLUSTER_NAME-eks-self \
                --flavor=${SELF_MANAGED_TYPE} \
                --target-namespace=${AWS_REGION} \
                --kubernetes-version=${KUBERNETES_VERSION} \
                --worker-machine-count=${WORKER_MACHINE_COUNT} \
                > .aws-cluster-init/templates/$CLUSTER_NAME-eks-self.yaml
            fi

            else
                clusterctl config cluster $CLUSTER_NAME \
                --infrastructure=aws \
                --target-namespace=${AWS_REGION}  \
                --kubernetes-version=${KUBERNETES_VERSION} \
                --control-plane-machine-count=${CONTROL_PLAN_MACHINE_COUNT} \
                --worker-machine-count=${WORKER_MACHINE_COUNT} \
                > ./aws-cluster-init/templates/$CLUSTER_NAME.yaml
    fi


# Create Namespace, test config, 
kubectl create ns ${AWS_REGION} && kubectl apply -f ./aws-cluster-init/templates/$CLUSTER_NAME.yaml

# get kubeconfig for cluster 
kubectl --namespace=${AWS_REGION} get secret $CLUSTER_NAME-kubeconfig \
   -o jsonpath={.data.value} | base64 --decode \
   > $CLUSTER_NAME.conf

export KUBECONFIG=./aws-cluster-init/templates/$CLUSTER_NAME.conf