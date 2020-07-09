resource "kubernetes_namespace" "microservice-namespace" {
  metadata {
    annotations = {
      name = "microservice-namespace"
    }

    labels = {
      namespace = "microservice-namespace"
    }

    name = "microservice-namespace"
  }
  depends_on = [var.depends_on_nginx_plus]
}