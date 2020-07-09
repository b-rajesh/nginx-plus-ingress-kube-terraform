resource "kubernetes_deployment" "alert-manager-deployment" {
  depends_on = [kubernetes_config_map.alertmanager-configmap-templates, kubernetes_namespace.monitoring-namespace]

  metadata {
    name      = "alert-manager-deployment"
    namespace = "monitoring"
    annotations = {
      "configmap.reloader.stakater.com/reload" = "alertmanager-config"
      "configmap.reloader.stakater.com/reload" = "alertmanager-templates"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "alertmanager"
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
          app = "alertmanager"
        }
      }

      spec {
        container {
          name  = "alertmanager"
          image = "prom/alertmanager:latest"
          args  = ["--config.file=/etc/alertmanager/config.yml", "--storage.path=/alertmanager"]

          port {
            name           = "alertmanager"
            container_port = 9093
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/alertmanager"
          }

          volume_mount {
            name       = "templates-volume"
            mount_path = "/etc/alertmanager-templates"
          }
          volume_mount {
            name       = "alertmanager"
            mount_path = "/alertmanager"
          }
        }
        volume {
          name = "config-volume"
          config_map {
            name = "alertmanager-configmap"
          }
        }

        volume {
          name = "templates-volume"
          config_map {
            name = "alertmanager-configmap-templates"
          }
        }

        volume {
          name = "alertmanager"
          empty_dir {
          }
        }
        # node_selector = {
        #   type = "master"
        # }
      }
    }
  }
}

resource "kubernetes_service" "alert-manager-service" {
  depends_on = [kubernetes_config_map.alertmanager-configmap-templates, kubernetes_namespace.monitoring-namespace]
  metadata {
    name      = "alertmanager"
    namespace = "monitoring"
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "9093"
    }
  }
  spec {
    selector = {
      app = "alertmanager"
    }
    port {
      port        = 9093
      target_port = 9093
      //node_port   = 31000
    }
    //type = "NodePort"
  }
}

