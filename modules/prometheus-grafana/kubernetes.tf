/******************************************
  Configure provider
 *****************************************/
provider "kubernetes" {
  config_path    = "~/.kube/config" 
  host                   = var.host
  token                  = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
  client_key             = var.client_key
  client_certificate     = var.client_certificate
}