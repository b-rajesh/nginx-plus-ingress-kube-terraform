resource "kubernetes_service" "weather-service" {
  depends_on = [kubernetes_namespace.microservice-namespace]
  metadata {
    name      = "weather-service"
    namespace = "microservice-namespace"
  }

  spec {
    selector = {
      app = kubernetes_deployment.weather-api-deployment.metadata[0].labels.app
    }
    session_affinity = "None"
    port {
      name        = "http"
      port        = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_deployment" "weather-api-deployment" {
  depends_on = [kubernetes_namespace.microservice-namespace]
  metadata {
    name = "weather-api-deployment"
    labels = {
      app = "weather-microservice"
    }
    namespace = "microservice-namespace"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "weather-microservice"
      }
    }
    template {
      metadata {
        labels = {
          app = "weather-microservice"
        }
      }
      spec {
          container {
          image = var.weather-api-image
          name  = "weather-microservice"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}


