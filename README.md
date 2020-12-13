# CLUSTER API 

What is Cluster API? 
Cluster api is a set of tooling design to “simplify the provisioning, upgrading and operating of multiple Kubernetes clusters”.  Infrastructure and kubernetes cluster configurations are defined in the same manner resources such as deployments and ingress are. Which allow for consistence when deploying clusters across cloud infrastructure. This model also allow easy adoption of cloud resources from multiple providers as implementations are now defined in yaml format. Cluster API also provides day two operational management  such as cluster upgrades, deletion, scaling etc. Cross infrastructure deployments. Making k8s cloud agnostic. 

## Implementation Spec 

Define a cluster spec,  map to EKS, than to aws provider, 

Target Cluster: cluster we create and manage

Boot Strap/ Management cluster 
Cluster that manages the target cluster 
Possibly the same cluster

Clusterctl 
Cli tool 

Provider implementation
APi spec for cloud 

Self Service 
Bootstrap cluster for devs?
Cluster acts on itself 


Management CLuster 
- Operations of concerns 
- Some secondary management cluster 
- Flexible 

Need to first deploy a management cluster. 

Cluster Controller 
Provider Cluster Actuator 


## Integration into Existing Environments 


## Getting Started 

  ```
    curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.11/clusterctl-darwin-amd64 -o clusterctl
    chmod +x ./clusterctl
    sudo mv ./clusterctl /usr/local/bin/clusterctl
    clusterctl version

  ```


checkout go docs for options

https://blog.heptio.com/the-kubernetes-cluster-api-de5a1ff870a5


move to spot instances 


cluster lifecycle managemenet is difficult 

Ecosystem is fragmented 

Difficult to build higher order functionailty 
managed control plane 
automated autoscaling repair upgrades 
consisten cross-cloud cluster management 
MachinePool autoscaling  groups 
