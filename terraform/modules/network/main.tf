# Using the default network for demo purposes
data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_global_address" "vpc-peering-address" {
  name          = "${var.project}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.name
}

resource "google_vpc_access_connector" "serverless-connector" {
  name          = "serverless-vpc-connector"
  provider      = google-beta
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = data.google_compute_network.default.name
}

resource "google_compute_global_address" "cloud-build-worker-range" {
  name          = "${var.project}-cb-workers"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.name
}

resource "google_service_networking_connection" "network-peering" {
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.vpc-peering-address.name,
    google_compute_global_address.cloud-build-worker-range.name
  ]
}
