resource "kubernetes_service_account" "kube-state-metrics-service-account" {
  depends_on = [kubernetes_deployment.prometheus-deployment]
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"    = "kube-state-metrics"
      "app.kubernetes.io/version" = "latest"
    }
  }
}
