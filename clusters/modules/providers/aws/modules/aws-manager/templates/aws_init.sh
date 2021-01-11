#!/bin/bash

export AWS_REGION=${aws_region} # This is used to help encode your environment variables
# export AWS_ACCESS_KEY_ID=${aws_access_key_id} # seems to read aws creds
# export AWS_SECRET_ACCESS_KEY=${aws_secrets_access_key}
export EXP_MACHINE_POOL=${exp_machine_pool}
export BOOTSTRAP_IAM=${bootstrap_iam}
export CLUSTERAWSADM_VERSION=${clusterawsadm_version}
export CLUSTERAWSADM_DISTRO=${clusterawsadm_distro}
export EXP_EKS=${exp_eks}
export EXP_EKS_IAM=${exp_eks_iam}
export EXP_EKS_ADD_ROLES=${exp_eks_add_roles}
export KUBECONFIG=${kubeconfig}
export KUBECONFIG_CONTEXT=${kubeconfig_context}
export MOVE_LOCAL_MANAGER=${move_local_manager}
export LOCAL_MANAGER_KUBECONFIG=${local_manager_kubeconfig}
export LOCAL_MANAGER_KUBECONFIG_CONTEXT=${local_manager_kubeconfig_context}



# Check if clusterawsadm exist or bootstraping
if ! command -v clusterawsadm &> /dev/null || $BOOTSTRAP_IAM = true
then
    
    curl -LJO https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/$CLUSTERAWSADM_VERSION/clusterawsadm-$CLUSTERAWSADM_DISTRO
    chmod +x ./clusterawsadm-$CLUSTERAWSADM_DISTRO
    mv ./clusterawsadm-$CLUSTERAWSADM_DISTRO  /usr/local/bin/clusterawsadm 
    clusterawsadm version

    # The clusterawsadm utility takes the credentials that you set as environment
    # variables and uses them to create a CloudFormation stack in your AWS account
    # with the correct IAM resources.
    clusterawsadm bootstrap iam create-cloudformation-stack --config ../../modules/providers/aws/modules/aws-init/templates/aws-bootstrap.yaml  

fi

# Create the base64 encoded credentials using clusterawsadm.
# This command uses your environment variables and encodes
# them in a value to be stored in a Kubernetes Secret.
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)



# Initialize the management cluster + kubeadm, eks support, dont worry will fail if exist on control cluster
clusterctl init --infrastructure=aws --control-plane aws-eks,kubeadm --bootstrap aws-eks,kubeadm --kubeconfig=$KUBECONFIG --kubeconfig-context=$KUBECONFIG_CONTEXT

# Finally move local manager to newly provisioned cluster.
if [ $MOVE_LOCAL_MANAGER = true ]
then 
    clusterctl move --kubeconfig=$LOCAL_MANAGER_KUBECONFIG --kubeconfig-context=$LOCAL_MANAGER_KUBECONFIG_CONTEXT  --to-kubeconfig=$KUBECONFIG --to-kubeconfig-context=$KUBECONFIG_CONTEXT --namespace=$AWS_REGION
fi 
exit
