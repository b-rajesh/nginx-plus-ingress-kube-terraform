/******************************************
  Configure provider
 *****************************************/
provider "kubernetes" {
  config_path    = "~/.kube/config"
  host                   = var.host
  token                  = var.token
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
  client_certificate     = var.client_certificate
}