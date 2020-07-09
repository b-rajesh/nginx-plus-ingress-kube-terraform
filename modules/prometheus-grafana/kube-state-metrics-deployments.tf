resource "kubernetes_deployment" "kube-state-metrics-deployment" {
  depends_on = [kubernetes_cluster_role.kube-state-metrics-cluster-role]
  metadata {
    name = "kube-state-metrics"
    labels = {
      "app.kubernetes.io/name"    = "kube-state-metrics"
      "app.kubernetes.io/version" = "latest"
    }
    namespace = "kube-system"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kube-state-metrics"
      }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = "33%"
      }
    } 
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"    = "kube-state-metrics"
          "app.kubernetes.io/version" = "latest"
        }
      }
      spec {
        container {
          image = "quay.io/coreos/kube-state-metrics:latest"
          name  = "kube-state-metrics"
          port {
            container_port = 8080
            name           = "http-metrics"
          }
          port {
            container_port = 8081
            name           = "telemetry"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }
            initial_delay_seconds = 5
            timeout_seconds       = 5
          }
          readiness_probe {
            http_get {
              path = "/"
              port = 8081
            }
            initial_delay_seconds = 5
            timeout_seconds       = 5
          }
        }

        node_selector        = var.node_selector
        automount_service_account_token = true
        service_account_name = kubernetes_service_account.kube-state-metrics-service-account.metadata[0].name
      }
    }
  }
}

resource "kubernetes_service" "kube-state-metrics-service" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"    = "kube-state-metrics"
      "app.kubernetes.io/version" = "latest"
    }
  }
  spec {
    cluster_ip = "None"
    selector = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
    port {
      name        = "http-metrics"
      port        = 8080
      target_port = "http-metrics"
    }
    port {
      name        = "telemetry"
      port        = 8081
      target_port = "telemetry"
    }
  }
}

