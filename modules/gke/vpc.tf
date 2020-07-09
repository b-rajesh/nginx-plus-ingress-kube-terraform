# Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  depends_on = [var.depends_on_kic]
  name                    = var.network
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnetwork
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.subnetwork_cidr

}

