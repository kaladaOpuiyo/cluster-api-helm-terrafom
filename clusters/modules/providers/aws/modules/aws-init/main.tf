
data "template_file" "aws_init" {
  template = file("${path.module}/templates/aws_init.sh")

  vars = {
    aws_access_key_id      = var.aws_access_key_id
    aws_region             = var.aws_region
    aws_secrets_access_key = var.aws_secrets_access_key
    bootstrap_iam          = var.bootstrap_iam
    clusterawsadm_distro   = var.clusterawsadm_distro
    clusterawsadm_version  = var.clusterawsadm_version
    exp_eks                = var.exp_eks
    exp_eks_add_roles      = var.exp_eks_add_roles
    exp_eks_iam            = var.exp_eks_iam
    exp_machine_pool       = var.exp_machine_pool
    kubeconfig             = var.kubeconfig
    kubeconfig_context     = var.kubeconfig_context
  }


}

resource "null_resource" "aws_init" {

  # Trigger when the script when variables change
  triggers = {
    script_sha = sha256(file("${path.module}/templates/aws_init.sh"))
  }

  provisioner "local-exec" {
    command     = data.template_file.aws_init.rendered
    interpreter = ["/bin/bash", "-c"]
  }
}
