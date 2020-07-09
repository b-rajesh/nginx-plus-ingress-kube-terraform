output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks-cluster.id
}

output "cluster_node_pool_id" {
  value = azurerm_kubernetes_cluster_node_pool.aks-cluster-application-node-pool.id
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host
}

