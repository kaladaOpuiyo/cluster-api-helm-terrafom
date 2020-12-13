#!bin/bash 


export CLUSTER_NAME=${cluster_name}
export AWS_REGION=${region} # This is used to help encode your environment variables
# export AWS_ACCESS_KEY_ID=${aws_access_key_id} # seems to read aws creds
# export AWS_SECRET_ACCESS_KEY=${aws_secrets_access_key}
export AWS_SSH_KEY_NAME=${ssh_key_name}
export AWS_CONTROL_PLANE_MACHINE_TYPE=${aws_control_plane_machine_type}
export AWS_NODE_MACHINE_TYPE=${aws_node_machine_type}
export CONTROL_PLAN_MACHINE_COUNT=${control_plan_machine_count}
export WORKER_MACHINE_COUNT=${worker_machine_count}
export EXP_MACHINE_POOL=${exp_machine_pool}
export BOOTSTRAP_IAM=${bootstrap_iam}
export CLUSTERAWSADM_VERSION=${clusterawsadm_version}
export CLUSTERAWSADM_DISTRO=${clusterawsadm_distro}
export EXP_EKS=${exp_eks}
export EXP_EKS_IAM=${exp_eks_iam}
export EXP_EKS_ADD_ROLES=${exp_eks_add_roles}
export FLAVOR=${flavor} # Options eks, eks-managedmachinepool

if ! command -v clusterawsadm &> /dev/null ||
    then
        # Generate base config
        if [ ${eks} = true ]
            then
                    clusterctl config cluster $CLUSTER_NAME-eks \
                    --flavor=${FLAVOR} \
                    --target-namespace=${AWS_REGION} \
                    --kubernetes-version=${KUBERNETES_VERSION} \
                    --worker-machine-count=${WORKER_MACHINE_COUNT} \
                    > ./$CLUSTER_NAME-eks.yaml

                else
                    clusterctl config cluster $CLUSTER_NAME \
                    --target-namespace=${AWS_REGION}  \
                    --kubernetes-version=${KUBERNETES_VERSION} \
                    --control-plane-machine-count=${CONTROL_PLAN_MACHINE_COUNT} \
                    --worker-machine-count=${WORKER_MACHINE_COUNT} \
                    > ./$CLUSTER_NAME.yaml
        fi
fi