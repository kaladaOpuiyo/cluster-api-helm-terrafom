locals {
  name            = "kubeadm-aws-cluster"
  calico_manifest = "https://docs.projectcalico.org/${var.calico_version}/manifests/calico.yaml"
  kubeconfig      = pathexpand("~/.kube/${var.cluster_name}.conf")
}

data "template_file" "values" {
  template = file("${path.module}/templates/values.yaml")

  vars = {
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
    region                          = var.region
    worker_replicas                 = var.worker_replicas
    vpc_cidr_block                  = var.vpc_cidr_block
  }
}


resource "helm_release" "kubeadm_aws_cluster" {
  chart     = "${path.module}/chart/${local.name}"
  name      = local.name
  namespace = var.region

  values = [data.template_file.values.rendered]

}

resource "null_resource" "wait_for_cluster" {

  provisioner "local-exec" {
    command = "while [ \"`kubectl get kubeadmcontrolplane -n ${helm_release.kubeadm_aws_cluster.namespace} ${var.cluster_name}-control-plane  | awk 'NR>1 {print $2}'`\" != \"true\" ]; do sleep 5; echo \"waiting for cluster to create...\"; done"

  }
}

resource "null_resource" "kubeconfig" {

  triggers = {
    wait_for_cluster = join(",", null_resource.wait_for_cluster.*.id)
    script_sha       = sha256(file("${path.module}/main.tf"))
  }
  provisioner "local-exec" {
    command = "sleep 30 && kubectl  --namespace=${helm_release.kubeadm_aws_cluster.namespace} get secret ${var.cluster_name}-kubeconfig -o jsonpath={.data.value} | base64 --decode > ${local.kubeconfig}"

  }

}


resource "null_resource" "calico" {

  triggers = {
    kube_config_id = join(",", null_resource.kubeconfig.*.id)
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${local.kubeconfig} --namespace kube-system  apply -f  ${local.calico_manifest}"

  }
}





