module "api-deployment" {
  source = "./modules/apis"

  load_config_file       = true
  tls_crt                = file("default.crt")
  tls_key                = file("default.key")
  image                  = "ingress/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  host                   = ""
  token                  = ""
  cluster_ca_certificate = ""
  client_key             = ""
  client_certificate     = ""
  weather-api-image      = var.weather-api-image
  echo-api-image         = var.echo-api-image
  swapi-image            = var.swapi-image
  depends_on_nginx_plus  = [module.nginx-plus-ingress-deployment.lb_ip]
}

locals {
  external_loadbalancer = module.nginx-plus-ingress-deployment.lb_ip
  #grafana_dashboard_url = module.prometheus.lb_ip
}

module "nginx-plus-ingress-deployment" {
  source = "./modules/nginx-plus"

  tls_crt                   = file("default.crt")
  tls_key                   = file("default.key")
  name_of_ingress_container = var.name_of_ingress_container
  ingress_conroller_version = var.ingress_conroller_version
  image                     = "ingress/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  load_config_file          = true
  host                      = ""
  token                     = ""
  cluster_ca_certificate    = ""
  client_key                = ""
  client_certificate        = ""
  depends_on_kube           = ["true"]
}

module "kic" {
  source                        = "./modules/kic"
  ingress_conroller_version     = var.ingress_conroller_version
  ingress_controller_prefix     = "ingress"
  ingress_controller_image_name = var.ingress_controller_image_name
}

resource "random_pet" "myprefix" {
  length = 1
  prefix = var.prefix
}

