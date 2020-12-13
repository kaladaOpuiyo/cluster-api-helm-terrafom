# # Create Namespace, test config, 
# kubectl create ns ${AWS_REGION} && kubectl apply -f ./aws-cluster-init/templates/$CLUSTER_NAME.yaml

# # get kubeconfig for cluster 
# kubectl --namespace=${AWS_REGION} get secret $CLUSTER_NAME-kubeconfig \
#    -o jsonpath={.data.value} | base64 --decode \
#    > $CLUSTER_NAME.conf

# export KUBECONFIG=./aws-cluster-init/templates/$CLUSTER_NAME.conf