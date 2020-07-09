resource "kubernetes_service" "nginx-ingress-service" {
  metadata {
    name      = "ext-loadbalancer-nginxplus"
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_daemonset.nginx-ingress-deployment.metadata[0].labels.app
    }

    session_affinity = "ClientIP"
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = 80
    }
    port {
      name        = "dashboard"
      protocol    = "TCP"
      port        = 9080
      target_port = 8086
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = 8443
      target_port = 443
    }
    type = "LoadBalancer"
  }
}
resource "kubernetes_daemonset" "nginx-ingress-deployment" {
  metadata {
    name = "nginx-plus-ingress-controller"
    labels = {
      app = "nplus-ingerss-ctrl"
    }
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        app = "nplus-ingerss-ctrl"
      }
    }
    template {
      metadata {
        labels = {
          app = "nplus-ingerss-ctrl"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "9500"
        }
      }
      spec {
        automount_service_account_token = true
        image_pull_secrets {
          name = kubernetes_secret.nginx-plus-ingress-default-secret.metadata.0.name
        }
        service_account_name = kubernetes_service_account.nginx-plus-ingress-sa.metadata[0].name
        container {
          image = var.image 
          name  = var.name_of_ingress_container
          port {
            container_port = 80
          }
          port {
            container_port = 8086
          }
          port {
            container_port = 9500
          }
          port {
            container_port = 443
          }
          security_context {
            allow_privilege_escalation = true
            run_as_user                = 101
            capabilities {
              drop = [
                "ALL"
              ]
              add = [
                "NET_BIND_SERVICE"
              ]
            }
          }
          env {
            name  = "POD_NAMESPACE"
            value = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
          }
          env {
            name  = "POD_NAME"
            value = "nginx-plus-ingress-controller-pod" #revisit
          }
          args = concat([
            "-nginx-plus",
            "-nginx-configmaps=${kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name}/${kubernetes_config_map.nginx-ingress-config-map.metadata.0.name}",
            "-default-server-tls-secret=${kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name}/${kubernetes_secret.nginx-plus-ingress-default-secret.metadata.0.name}",
            "-health-status",
            "-nginx-status-allow-cidrs=120.148.224.94",
            "-nginx-status-port=8086",
            "-enable-prometheus-metrics",
            "-prometheus-metrics-listen-port=9500"
            //"-v=3" # Enables extensive logging. Useful for troubleshooting.
          ])
        }

      }
    }
  }
  depends_on = [kubernetes_namespace.nginx-plus-ingress-ns, kubernetes_cluster_role_binding.nginx-plus-ingress-cluster-role-binding]
}

/*
resource "kubernetes_deployment" "nginx-ingress-deployment" {
  metadata {
    name = "nginx-plus-ingress-controller"
    labels = {
      app = "nplus-ingerss-ctrl"
    }
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "nplus-ingerss-ctrl"
      }
    }
    template {
      metadata {
        labels = {
          app = "nplus-ingerss-ctrl"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "9500"
        }
      }
      spec {
        automount_service_account_token = true
        image_pull_secrets {
          name = kubernetes_secret.nginx-plus-ingress-default-secret.metadata.0.name
        }
        service_account_name = kubernetes_service_account.nginx-plus-ingress-sa.metadata[0].name
        container {
          image = var.image
          name  = var.name_of_ingress_container
          port {
            container_port = 80
          }
          port {
            container_port = 8086
          }
          port {
            container_port = 9500
          }
          port {
            container_port = 443
          }
          security_context {
            allow_privilege_escalation = true
            run_as_user                = 101
            capabilities {
              drop = [
                "ALL"
              ]
              add = [
                "NET_BIND_SERVICE"
              ]
            }
          }
          env {
            name  = "POD_NAMESPACE"
            value = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
          }
          env {
            name  = "POD_NAME"
            value = "nginx-plus-ingress-controller-pod" #revisit
          }
          args = concat([
            "-nginx-plus",
            "-nginx-configmaps=${kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name}/${kubernetes_config_map.nginx-ingress-config-map.metadata.0.name}",
            "-default-server-tls-secret=${kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name}/${kubernetes_secret.nginx-plus-ingress-default-secret.metadata.0.name}",
            "-health-status",
            //"-nginx-status-allow-cidrs=120.148.224.94",
            "-nginx-status-port=8086",
            "-enable-prometheus-metrics",
            "-prometheus-metrics-listen-port=9500"
            //"-v=3" # Enables extensive logging. Useful for troubleshooting.
          ])
        }

      }
    }
  }
  depends_on = [kubernetes_namespace.nginx-plus-ingress-ns, kubernetes_cluster_role_binding.nginx-plus-ingress-cluster-role-binding]
}

*/
