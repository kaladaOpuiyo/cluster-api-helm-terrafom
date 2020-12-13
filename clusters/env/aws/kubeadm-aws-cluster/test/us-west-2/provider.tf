provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

provider "helm" {
  debug       = true
  helm_driver = "secret"

  kubernetes {
    # cluser_ca_certificate = base64decode(module.cluster.cluster_ca)
    config_context = "kind-kind"
    # host                  = module.cluster.cluster_endpoint
    # token                 = data.external.cluster_token.result["token"]
  }

}
