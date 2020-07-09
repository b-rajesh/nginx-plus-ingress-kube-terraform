output "region" {
  value       = var.region
  description = "region"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "stable_channel_version" {
  value = data.google_container_engine_versions.kubernetes_version.latest_node_version
}

output "primary_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "node_pool" {
  value = google_container_node_pool.primary_node_pool
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = local.cluster_endpoint
  depends_on = [
    /* Nominally, the endpoint is populated as soon as it is known to Terraform.
    * However, the cluster may not be in a usable state yet.  Therefore any
    * resources dependent on the cluster being up will fail to deploy.  With
    * this explicit dependency, dependent resources can wait for the cluster
    * to be up.
    */
    google_container_cluster.primary,
    google_container_node_pool.primary_node_pool,
  ]
}
output primary_cluster_endpoint {
  value = "https://${local.cluster_endpoint}"
}
output primary_cluster_token {
  value = data.google_client_config.default.access_token
}

output primary_cluster_ca_certificate {
  value = base64decode(local.cluster_ca_certificate)
}
