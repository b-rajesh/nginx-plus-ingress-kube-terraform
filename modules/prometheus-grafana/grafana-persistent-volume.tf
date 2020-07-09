/*
resource "kubernetes_persistent_volume_claim" "grafana-pvc" {
  metadata {
    name      = "grafana-pvc"
    namespace = "monitoring"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "standard"
    //volume_name = "${kubernetes_persistent_volume.grafana-pvc.metadata.0.name}"
  }
}

*/