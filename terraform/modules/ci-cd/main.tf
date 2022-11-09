# Using the default network for demo purposes
data "google_compute_network" "default" {
  name = "default"
}

resource "google_artifact_registry_repository" "docker-registry" {
  provider      = google-beta
  location      = var.region
  repository_id = var.project
  description   = "Docker repository for ${var.project}"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "cloud-build-pipeline" {
  name        = "${var.project}-build-push-deploy"
  description = "Builds, scans and pushes the docker images to the registry and deploy to cloud run"

  github {
    owner = var.github_repository.owner
    name  = var.github_repository.repository
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"

  service_account = google_service_account.cloud-build-sa.id
  depends_on = [
    google_artifact_registry_repository.docker-registry
  ]
}

resource "google_service_account" "cloud-build-sa" {
  account_id = "${var.project}-cb"
}

resource "google_project_iam_member" "cloud-build-sa-roles" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/logging.logWriter",
    "roles/cloudsql.client",
    "roles/cloudbuild.workerPoolUser"
  ])

  project = var.project_id
  member  = "serviceAccount:${google_service_account.cloud-build-sa.email}"
  role    = each.value
}

resource "google_cloudbuild_worker_pool" "pool" {
  name     = "${var.project}-pool"
  location = var.region
  worker_config {
    disk_size_gb = 100
    machine_type = "e2-standard-2"
    no_external_ip = false
  }
  network_config {
    peered_network = data.google_compute_network.default.id
  }
}