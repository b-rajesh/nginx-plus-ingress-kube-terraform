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
resource "kubernetes_namespace" "nginx-plus-ingress-ns" {
  metadata {
    annotations = {
      name = "nginx-plus-ingress-namespace"
    }

    labels = {
      namespace = "nginx-plus-ingress-ns"
    }

    name = "nginx-plus-ingress-ns"
  }
  depends_on = [var.depends_on_kube]
}

resource "kubernetes_service_account" "nginx-plus-ingress-sa" {
  metadata {
    name      = "nginx-plus-ingress-service-account"
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }
  automount_service_account_token = true
  //secret = kubernetes_secret.nginx-plus-ingress-default-secret.metadata.0.name
  image_pull_secret {
    name = "nginx-plus-ingress-default-secret" #revisit
  }
  depends_on = [var.depends_on_kube]
}

resource "kubernetes_secret" "nginx-plus-ingress-default-secret" {
  metadata {
    name      = "nginx-plus-ingress-default-secret"
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.nginx-plus-ingress-sa.metadata.0.name
      "kubernetes.io/service-account.uid"  = kubernetes_service_account.nginx-plus-ingress-sa.metadata.0.uid
    }
  }
  data = {
    "tls.crt" = var.tls_crt,
    "tls.key" = var.tls_key
  }
  type       = "kubernetes.io/tls"
  depends_on = [var.depends_on_kube]
}
/*
resource "kubernetes_secret" "nginx-mesh-registry-key" {
  metadata {
    name      = "nginx-mesh-registry-key"
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.nginx-plus-ingress-sa.metadata.0.name
      "kubernetes.io/service-account.uid"  = kubernetes_service_account.nginx-plus-ingress-sa.metadata.0.uid
    }
  }
  data = {
    ".dockerconfigjson"= "<base64-encoded-key>",
  }
  type       = "kubernetes.io/dockerconfigjson"
}
*/
resource "kubernetes_config_map" "nginx-ingress-config-map" {
  metadata {
    name      = "nginx-ingress-config-map"
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }

  data = {
    worker-processes     = "24"
    worker-connections   = "100000"
    worker-rlimit-nofile = "102400"
    worker-cpu-affinity  = "auto 111111111111111111111111"
    keepalive            = "200"
    //main-template        = "${file("${path.module}/main_template_file.conf")}"
  }

}


