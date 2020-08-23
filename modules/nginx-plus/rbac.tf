resource "kubernetes_cluster_role" "nginx-plus-ingress-cluster-role" {
  metadata {
    name = "nginx-plus-ingress-cluster-role"
    /*labels = {
      "rbac.authorization.k8s.io/aggregate-to-admin" =  "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
      } */
  }
  rule {
    api_groups = ["k8s.nginx.org"]
    resources  = ["virtualservers/status", "virtualserverroutes/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = ["k8s.nginx.org"]
    resources  = ["virtualservers", "virtualserverroutes", "globalconfigurations", "transportservers", "policies"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch", "list"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch", "update", "create"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["services", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  depends_on = [kubernetes_service_account.nginx-plus-ingress-sa, null_resource.cluster]
}

resource "kubernetes_cluster_role_binding" "nginx-plus-ingress-cluster-role-binding" {
  metadata {
    name = "nginx-plus-ingress-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "nginx-plus-ingress-cluster-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nginx-plus-ingress-sa.metadata.0.name
    namespace = kubernetes_namespace.nginx-plus-ingress-ns.metadata[0].name
  }
  depends_on = [kubernetes_cluster_role.nginx-plus-ingress-cluster-role, null_resource.cluster]
}