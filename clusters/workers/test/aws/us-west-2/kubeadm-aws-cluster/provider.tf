provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

provider "helm" {
  debug       = true
  helm_driver = "secret"

  kubernetes {
    config_context = ""
    config_path    = var.manager_kubeconfig
  }

}
