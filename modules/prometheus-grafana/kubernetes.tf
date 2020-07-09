/******************************************
  Configure provider
 *****************************************/
provider "kubernetes" {
  load_config_file       = var.load_config_file
  host                   = var.host
  token                  = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
  client_key             = var.client_key
  client_certificate     = var.client_certificate
}