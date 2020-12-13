aws_region                     = "us-west-2"
aws_access_key_id              = ""
aws_secrets_access_key         = ""
exp_machine_pool               = true
bootstrap_iam                  =  true 
clusterawsadm_version          = "v0.6.3"
clusterawsadm_distro           = "darwin-amd64"
exp_eks                        = true
exp_eks_iam                    = true
exp_eks_add_roles              = true 
kubeconfig                     = "$HOME/.kube/config"
kubeconfig_context             = "kind-kind"
# create_kind_cluster             = true
# destroy_kind_cluster            