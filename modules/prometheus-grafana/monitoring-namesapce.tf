resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    annotations = {
      name = "monitoring"
    }
    name = "monitoring"
  }
   depends_on = [var.depends_on_nginx_plus]
}