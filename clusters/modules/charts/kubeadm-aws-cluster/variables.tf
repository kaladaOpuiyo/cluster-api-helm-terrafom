variable "bastion_host_enabled" {
  default = false
}
variable "cluster_name" {}
variable "control_plane_instance_replicas" {}
variable "control_plane_instance_type" {}
variable "ingress_instance_type" {}
variable "ingress_replicas" {}
variable "kubernetes_version" {}
variable "pod_cidr_block" {}
variable "region" {}
variable "ssh_key_name" {}
variable "worker_instance_type" {}
variable "worker_replicas" {}
