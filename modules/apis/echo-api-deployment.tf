resource "kubernetes_service" "echo-service" {
  depends_on = [kubernetes_namespace.microservice-namespace]
  metadata {
    name      = "echo-service"
    namespace = "microservice-namespace"
  }

  spec {
    selector = {
      app = kubernetes_deployment.echo-api-deployment.metadata[0].labels.app
    }
    session_affinity = "None"
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_deployment" "echo-api-deployment" {
  depends_on = [kubernetes_namespace.microservice-namespace]
  metadata {
    name = "echo-api-deployment"
    labels = {
      app = "echo-microservice"
    }
    namespace = "microservice-namespace"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "echo-microservice"
      }
    }
    template {
      metadata {
        labels = {
          app = "echo-microservice"
        }
      }
      spec {
          container {
          image = var.echo-api-image
          name  = "echo-microservice"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}


