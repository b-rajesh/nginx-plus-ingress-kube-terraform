resource "kubernetes_deployment" "grafana-deployment" {
  depends_on = [kubernetes_config_map.grafana-configmap, kubernetes_namespace.monitoring-namespace]//, kubernetes_persistent_volume_claim.grafana-pvc]

  metadata {
    name      = "grafana"
    namespace = "monitoring"
    labels = {
      app = "grafana"
    }
    annotations = {
      "configmap.reloader.stakater.com/reload" = "grafana-datasources"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "grafana"
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
          app = "grafana"
        }
      }

      spec {
        container {
          name  = "grafana"
          image = "grafana/grafana:latest"
          port {
            name           = "grafana"
            container_port = 3000
          }

          resources {
            limits {
              cpu    = "1000m"
              memory = "2Gi"
            }
            requests {
              cpu    = "500m"
              memory = "1Gi"
            }
          }

          volume_mount {
            name       = "grafana-storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "grafana-datasources"
            mount_path = "/etc/grafana/provisioning/datasources"
            read_only  = false
          }
        }
        volume {
          name = "grafana-datasources"
          config_map {
            default_mode = "0777"
            name         = "grafana-datasources"
          }
        }
        volume {
          name = "grafana-storage"
          empty_dir {

          }
          #persistent_volume_claim {
            #claim_name = "grafana-pvc"
          #}
        }
        automount_service_account_token = true

        # node_selector = {
        #   type = "master"
        # }
        security_context {
          fs_group = "472"
        }
      }
    }
  }
}

resource "kubernetes_service" "grafana-service" {
  depends_on = [kubernetes_config_map.grafana-configmap, kubernetes_namespace.monitoring-namespace]
  metadata {
    name      = "grafana"
    namespace = "monitoring"
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "3000"
    }
  }
  spec {
    selector = {
      app = "grafana"
    }
    session_affinity = "ClientIP"
    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

