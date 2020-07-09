resource "kubernetes_service_account" "node-exporter-service-account" {
  depends_on = [kubernetes_deployment.prometheus-deployment, kubernetes_namespace.monitoring-namespace]
  metadata {
    name      = "node-exporter"
    namespace = "monitoring"
  }
}
