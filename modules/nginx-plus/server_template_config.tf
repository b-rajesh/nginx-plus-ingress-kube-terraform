resource "kubernetes_config_map" "nginx_ingress_server_config_map" {
  metadata {
    name      = "nginx-ingress-server-config-map"
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }
  data = {
    server-snippets        = "${file("${path.module}/server_template_file.conf")}"
  }

}


