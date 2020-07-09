resource "kubernetes_config_map" "prometheus-configmap" {
  depends_on = [kubernetes_cluster_role.clusterRole, kubernetes_namespace.monitoring-namespace]
  metadata {
    name      = "prometheus-server-conf"
    namespace = "monitoring"
    labels = {
      name = "prometheus-server-conf"
    }
  }
  data = {
    "prometheus.rules" = file("${path.module}/prometheus.rules.yml")
    "prometheus.yml"   = file("${path.module}/prometheus-config.yml")
  }
}

