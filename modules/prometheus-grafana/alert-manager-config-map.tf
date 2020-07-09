resource "kubernetes_config_map" "alertmanager-configmap" {
  depends_on = [kubernetes_namespace.monitoring-namespace, kubernetes_cluster_role.kube-state-metrics-cluster-role]
  metadata {
    name      = "alertmanager-configmap"
    namespace = "monitoring"
  }
  data = {
    "config.yml" = file("${path.module}/alert-manager-config.yml")
  }
}

