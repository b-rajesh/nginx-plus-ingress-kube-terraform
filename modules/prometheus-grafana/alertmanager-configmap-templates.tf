resource "kubernetes_config_map" "alertmanager-configmap-templates" {
  depends_on = [kubernetes_namespace.monitoring-namespace, kubernetes_config_map.alertmanager-configmap]
  metadata {
    name      = "alertmanager-configmap-templates"
    namespace = "monitoring"
  }
  data = {
    "default.tmpl" = file("${path.module}/alert-manager-default-template.tmpl")
  }
}

