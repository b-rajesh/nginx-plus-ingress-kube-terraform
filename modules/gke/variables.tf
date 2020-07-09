variable "gke_username" {}
variable "gke_password" {}
variable "gke_num_nodes" {}
variable "network" {}
variable "subnetwork" {}
variable "gke_cluster_name" {}
variable "initial_node_count" {}
variable "project_id" {}

variable "region" {}

variable "kubernetes_version" {}
variable "machine_type" {}
variable "tag_1_node_pool" {}
variable "tag_2_node_pool" {}
variable "environment" {}
variable "unique_user_id" {}
variable "subnetwork_cidr" {}
locals {
  cluster_endpoint                = google_container_cluster.primary.endpoint
  cluster_ca_certificate          = local.cluster_master_auth_map["cluster_ca_certificate"]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]
  cluster_master_auth_list_layer1 = local.cluster_output_master_auth
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]

  cluster_output_master_auth = concat(google_container_cluster.primary.*.master_auth, [])

}
variable   "ingress_conroller_version" {}
variable   "ingress_controller_prefix" {}
variable   "ingress_controller_image_name" {}
variable depends_on_kic {}
