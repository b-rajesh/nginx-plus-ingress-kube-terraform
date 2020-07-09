variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "fwprivate_ip" {
  default = "Internet" //https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview
}

variable "default_node_pool_count" {
  description = "Enter no. of nodes for your default node(system) to be provisoned"
}

variable "application_node_pool_count" {
  description = "Enter no. of nodes for your application to be deployed"
  default     = 1
}

variable "kubernetes_version" {
  description = "Enter the Stable Kuberentes version to run for AKS - Refer here [az aks get-versions --location <your-location> --output table]"
}

variable "vpc_cidr" {
  description = "Enter the CIDR for your VPC eg 10.1.0.0/16"
}

variable "vpc_subnet_cidr" {
  description = "Enter the CIDR for your subnet of VPC eg. 10.1.0.0/22"
}

variable "system_node_label_identifier" {
  description = "Enter unique value to identify default(system) node - to deploy your system apps to appropriate nodes"
}

variable "application_node_label_identifier" {
  description = "Enter unique value to identify application node - to deploy your apis & web-apps to appropriate nodes"
}

variable "environment" {
  description = "Enter the environment name to label"
}

variable   "ingress_conroller_version" {}
variable   "ingress_controller_prefix" {}
variable   "ingress_controller_image_name" {}
variable depends_on_kic {}
