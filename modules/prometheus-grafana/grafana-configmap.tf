resource "kubernetes_config_map" "grafana-configmap" {
  depends_on = [kubernetes_namespace.monitoring-namespace, kubernetes_deployment.alert-manager-deployment]
  metadata {
    name      = "grafana-datasources"
    namespace = "monitoring"
    labels = {
      name = "grafana-datasources"
    }
  }
  data = {
    "prometheus.yaml" = file("${path.module}/prometheus.yml")
  }
}

