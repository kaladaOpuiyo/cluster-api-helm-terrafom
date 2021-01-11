# Terraform-helm-cluster-api

  

What is Cluster API?

Cluster api is a set of tooling designed to “*simplify the provisioning, upgrading and operating of multiple Kubernetes clusters*”. Infrastructure and kubernetes cluster configurations are defined in the same manner resources such as deployments and ingress are. This allows for consistency when deploying clusters across cloud infrastructure. This model also allows easy adoption of cloud resources from multiple providers as implementations are now defined in yaml format and can be deploy with tools such as helm. Cluster API also provides day two operational management such as cluster upgrades, deletion, scaling etc.

  

The aim of this project is to create the resources necessary to start provisioning Kubernetes clusters using cluster-api. With this project you can set up a management cluster locally or within aws and use it to deploy worker clusters. The example here uses the kubeadm provider but allows for eks clusters as well.  

  

## Getting Started
You’ll need to have the following installed locally to utilize this project

-   terraform
-   clusterctl
-   kubectl
-   kind

The values set here are for testing `ONLY`. 

## Operations 

### Provision A Local Management Cluster with Kind 
Start by provisioning a management cluster locally with kind. Terraform module found here `clusters/managers/kind-aws-manager`

### Provision A Management Cluster in AWS
Before you begin head to the kind cluster and create a ns for the region you'd like to deploy clusters within. The project example is set to `us-west-2` ( `kubectl create ns us-west-2` for example ) The variable `move_local_manager`  is used to move the local cluster api objects to the newly provisioned  aws cluster. This also allows the aws cluster to manage itself. Terraform module can be found here `clusters/managers/aws-manager`. 

 **PLEASE NOTE**: Once your cluster has been moved out of the local management cluster, it will no longer be managed by helm. You can bring the resources under helm's mangement by performing a terraform state remove `terraform state rm  module.kubeadm_aws_cluster.helm_release.kubeadm_aws_cluster`, re-applying the helm chart to the new aws manager and annotating the resources with helm related values. A little cumbersome and at some point I will automate this as well. 

## Destroy the AWS Management Cluster
The simplest way I've found to destroy the management aws cluster is to move its api objects back to a local cluster used to create it and run terraform destroy on the module.
`clusterctl move --to-kubeconfig=$HOME/.kube/config --to-kubeconfig-context=kind-kind --namespace=us-west-2`
You can either use `terraform destory` if the kind cluster and associated charts still exist or `kubectl delete cluster -n us-west-2 manager-us-west-2-blue`.

### Deploy a work cluster. 
An example worker cluster deployment with helm is included. Terraform module found here`clusters/workers/test/aws/us-west-2/kubeadm-aws-cluster`



## Resources 
- https://cluster-api.sigs.k8s.io/introduction.html