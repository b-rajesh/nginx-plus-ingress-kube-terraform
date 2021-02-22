variable project_id {}
variable region {}
variable name_of_ingress_container {}
variable gke_kubernetes_version {
  description = "Enter the GKE supported kubernetes version : Run this to find out  gcloud container get-server-config --zone australia-southeast1 <-- Only specify major & minor version as shown here :::: eg 16.9."
}

variable "weather-api-image" {
  description = "Enter your name of the weather api docker iamge from dockerhub.io"
}
variable "echo-api-image" {
  description = "Enter your name of the weather api docker iamge from dockerhub.io"
}
variable "swapi-image" {
}
variable "gke_username" {
  description = "Enter gke username - usuall empty"
}

variable "gke_password" {
  description = "Enter gke password - usually empty "
}
variable "gke_num_nodes" {
  description = "number of gke nodes"
}
variable "network" {
  description = "The VPC network to host the cluster in"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
}

variable "machine_type" {
  description = "Enter the machine type to host GKE nodes"
}
variable "initial_node_count" {
  description = "Enter no of initial node count"
}
variable "tag_1_node_pool" {
  description = "Enter a tag value eg. 'created-by-yourname' - keep it lowercase"
}
variable "tag_2_node_pool" {
  description = "Enter a tag value eg. 'gke-node-pool-for-nginx-plus-ingress' - keep it lowercase"
}

variable "unique_user_id" {
  description = "Enter your unique name as unique for labeling no special character allowed "
}

variable "environment" {
  description = "Enter your environment name for labeling - keep it lowercase"
}

variable "subnetwork_cidr" {
  description = "Enter CIDR for your GKE subnet eg 10.10.0.0/24"
}

variable "gke_cluster_name" {
  description = "Enter unique gke cluster name eg. <yourname>-nplus-cluster - keep it lower case"
}
variable gke_container_registry_region {
  description = "Enter the region where you want your image to be uploaded eg asia.gcr.io or eu.gcr.io or us.gcr.io"
}
###########################################################################################################

variable "prefix" {
  description = "A prefix used for all resources in this example - keep it within 3-5 letters"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}


variable "default_node_pool_count" {
  description = "Enter no. of nodes for your default node(system) to be provisoned"
}

variable "application_node_pool_count" {
  description = "Enter no. of nodes for your application to be deployed"
}

variable "aks_kubernetes_version" {
  description = "Enter the Stable Kuberentes version to run for AKS - Refer here [az aks get-versions --location <your-location> --output table]"
}

variable "vpc_cidr" {
  description = "Enter the CIDR for your VPC eg 10.1.0.0/16"
}

variable "vpc_subnet_cidr" {
  description = "Enter the CIDR for your subnet of VPC eg. 10.1.0.0/24"

}

variable "system_node_label_identifier" {
  description = "Enter unique value to identify default(system) node - to deploy your system apps to appropriate nodes"
}

variable "application_node_label_identifier" {
  description = "Enter unique value to identify application node - to deploy your apis & web-apps to appropriate nodes"
}
variable "aks_ingress_controller_prefix" {
  description = "Enter the prefix for the ingress controller to be build.This would be used to upload the container to ACR"
  default     = "nginxingresscontroller"
}

########################################################################################################

variable "ingress_conroller_version" { default = "1.7.2" }

variable "ingress_controller_image_name" { default = "nginx-plus-ingress" }
