resource "kubernetes_cluster_role" "nginx-plus-app-protect-cluster-role" {
  metadata {
    name = "nginx-ingress-app-protect"
  }
  rule {
    api_groups = ["appprotect.f5.com"]
    resources  = ["appolicies", "aplogconfs"]
    verbs      = ["get", "list", "watch"]
  }
  depends_on = [kubernetes_service_account.nginx-plus-ingress-sa]
}

resource "kubernetes_cluster_role_binding" "nginx-plus-app-protect-cluster-role-binding" {
  metadata {
    name = "nginx-ingress-app-protect"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "nginx-ingress-app-protect"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nginx-plus-ingress-sa.metadata.0.name
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }
  depends_on = [kubernetes_cluster_role.nginx-plus-app-protect-cluster-role ]
}