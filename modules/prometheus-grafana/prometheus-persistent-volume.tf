/*
resource "kubernetes_persistent_volume_claim" "prometheus-pvc" {
  metadata {
    name      = "ptometheus-pvc"
    namespace = "monitoring"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "3Gi"
      }
    }
    storage_class_name = "standard"
  }
}

*/