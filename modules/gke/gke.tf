
/******************************************
  Retrieve authentication token
 *****************************************/
data "google_client_config" "default" {
  provider = google
}

/******************************************
  Configure provider
 *****************************************/
provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${local.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
}

data "google_container_engine_versions" "kubernetes_version" {
  location       = var.region
  version_prefix = var.kubernetes_version
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.region
  node_version       = data.google_container_engine_versions.kubernetes_version.latest_node_version
  min_master_version = data.google_container_engine_versions.kubernetes_version.latest_node_version
  remove_default_node_pool = true //using a separately managed node pool , so deleting the default
  initial_node_count       = 1 // In regional or multi-zonal clusters, this is the number of nodes per zone.

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    username = var.gke_username
    password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region}"
  }
  provisioner "local-exec" {
    command = "docker push ${var.ingress_controller_prefix}/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  }
  provisioner "local-exec" {
    command = "docker rmi ${var.ingress_controller_prefix}/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_node_pool" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only", #to read uploaded image by you from GCR
      "https://www.googleapis.com/auth/cloud-platform",

    ]

    labels = {
      env = var.environment
      user = var.unique_user_id
    }

    # preemptible  = true
    machine_type = var.machine_type
    tags         = [var.tag_1_node_pool, var.tag_2_node_pool, var.environment, var.unique_user_id]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

