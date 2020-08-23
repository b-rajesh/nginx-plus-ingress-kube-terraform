# GKE specific variables
project_id = "You_GCP_Project_Id"
gke_kubernetes_version = "1.16."                                //  gcloud container get-server-config --zone australia-southeast1 <-- To find the available kube supoprted version for your region. Only specify major & minor version as shown here
unique_user_id         =       //your username would be unique 
tag_1_node_pool        =             //"created-by-xxx"
tag_2_node_pool        = "gke-node-pool-for-nginx-plus-ingress" //some meaningful tags
#If you specify a zone, the cluster will be a zonal cluster with a single cluster master. If you specify a region the cluster will be a regional cluster with multiple masters spread across zones in the region
region                 = "australia-southeast1"
gke_cluster_name       = "gke-cluster"
# number of nodes per instance group.
gke_num_nodes = 1
# The number of nodes to create in this cluster's default node pool, if you specify regional cluster above and make this initial_node_count as 3 , you would end up with 9 nodes - 3 nodes per zone in a region.
initial_node_count            = 1
network                       = "gke-vpc"
subnetwork                    = "gke-subnet"
machine_type                  = "n1-standard-1"
subnetwork_cidr               = "10.10.0.0/24"
gke_username                  = ""
gke_password                  = ""
gke_container_registry_region = "asia.gcr.io" //choose your gke region based on the above selected region
# common variables
environment = "nginx-raj-test"
# nginx plus ingress controller variables
name_of_ingress_container = "nginx-plus-ingress-container-1-8-1"
system_node_label_identifier      = "aks-system-node"
application_node_label_identifier = "aks-application-node"
vpc_subnet_cidr                   = "10.1.0.0/24"
vpc_cidr                          = "10.1.0.0/16"
prefix                            = "raj" //keep it within 3-5 letters as the code is also generating unique petname along with it.
# Variables for Testing APIs
weather-api-image             = "brajesh79/weather-api:v1" 
echo-api-image                = "brajesh79/http-https-echo"
ingress_controller_image_name = "nginx-plus-ingress"
ingress_conroller_version     = "1.8.1"
# Azure AKS
default_node_pool_count     = 1        // To ensure your cluster operates reliably, you should run at least 2 (two) nodes in the default node pool, as essential system services are running across this node pool.
aks_kubernetes_version      = "1.17.7" //Run to get right k8s version on aks for your region --> az aks get-versions --output table --location <your_location>
location                    = "australiasoutheast"
application_node_pool_count = 1
