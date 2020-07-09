variable "node_selector" {
  description = "Map of key value that will be used to select appropriate nodes"
  default = {
    "kubernetes.io/os" = "linux"
  }
}

variable  depends_on_nginx_plus {}
variable load_config_file  {}
variable  host {}
variable  token  {}
variable  cluster_ca_certificate {}
variable  client_key  {}
variable client_certificate {}
/*
variable "storage_class_name" {
  description = ""
  default = {
    "NFS"
  }
}

variable "grafana_persistent_volume_claim_storage" {
  description = ""
  default = {
    "1Gi"
  }
}

variable "prometheus_storage_class_name" {
  description = ""
    default = {
    "NFS"
  }
}

variable "prometheus_persistent_volume_claim_storage" {
  description = ""
    default = {
    "3Gi"
  }
}

*/