data "aws_region" "current" {}

module "kubeadm_aws_cluster" {
  source = "../../modules/charts/kubeadm-aws-cluster"

  bastion_host_enabled            = var.bastion_host_enabled
  cluster_name                    = var.cluster_name
  control_plane_instance_replicas = var.control_plane_instance_replicas
  control_plane_instance_type     = var.control_plane_instance_type
  ingress_instance_type           = var.ingress_instance_type
  ingress_replicas                = var.ingress_replicas
  kubernetes_version              = var.kubernetes_version
  pod_cidr_block                  = var.pod_cidr_block
  ssh_key_name                    = var.ssh_key_name
  worker_instance_type            = var.worker_instance_type
  region                          = data.aws_region.current.name
  worker_replicas                 = var.worker_replicas
  vpc_cidr_block                  = var.vpc_cidr_block
  cni_enable                      = var.cni_enable
  manager_kubeconfig              = "$HOME/.kube/config"

}

module "manager_aws" {
  source = "../../modules/providers/aws/modules/aws-manager"

  aws_access_key_id                = var.aws_access_key_id
  aws_region                       = var.aws_region
  aws_secrets_access_key           = var.aws_secrets_access_key
  bootstrap_iam                    = false
  clusterawsadm_distro             = var.clusterawsadm_distro
  clusterawsadm_version            = var.clusterawsadm_version
  exp_eks                          = var.exp_eks
  exp_eks_add_roles                = var.exp_eks_add_roles
  exp_eks_iam                      = var.exp_eks_iam
  exp_machine_pool                 = var.exp_machine_pool
  kubeconfig                       = module.kubeadm_aws_cluster.kubeconfig
  kubeconfig_context               = ""
  local_manager_kubeconfig         = "$HOME/.kube/config"
  local_manager_kubeconfig_context = "kind-kind"
  move_local_manager               = true

  depends_on = [module.kubeadm_aws_cluster]
}
