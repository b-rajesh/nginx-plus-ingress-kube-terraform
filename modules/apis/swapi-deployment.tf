resource "kubernetes_service" "swapi-service" {
  depends_on = [kubernetes_namespace.microservice-namespace]
  metadata {
    name      = "swapi-service"
    namespace = "microservice-namespace"
  }

  spec {
    selector = {
      app = kubernetes_deployment.swapi-api-deployment.metadata[0].labels.app
    }
    session_affinity = "None"
    port {
      name        = "http"
      port        = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_deployment" "swapi-api-deployment" {
  depends_on = [kubernetes_namespace.microservice-namespace]
  metadata {
    name = "swapi-api-deployment"
    labels = {
      app = "swapi-microservice"
    }
    namespace = "microservice-namespace"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "swapi-microservice"
      }
    }
    template {
      metadata {
        labels = {
          app = "swapi-microservice"
        }
      }
      spec {
          container {
          image = var.swapi-image
          name  = "swapi-microservice"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}


