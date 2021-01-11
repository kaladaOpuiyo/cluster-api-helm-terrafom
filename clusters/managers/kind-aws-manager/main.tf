data "aws_region" "current" {}




module "aws_manager" {
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
  kubeconfig                       = var.kubeconfig
  kubeconfig_context               = var.kubeconfig_context
  local_manager_kubeconfig         = ""
  local_manager_kubeconfig_context = ""
  move_local_manager               = false

  depends_on = [null_resource.kind]

}
# Force use of kind cluster here.
resource "null_resource" "kind" {

  provisioner "local-exec" {
    command     = "kind delete cluster && kind create cluster"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster"
  }
}
