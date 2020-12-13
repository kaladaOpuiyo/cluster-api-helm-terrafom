data "aws_region" "current" {}

module "kubeadm_aws_cluster" {
  source = "../../../../../modules/charts/kubeadm-aws-cluster"

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
}
