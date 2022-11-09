output "cloud-build-trigger" {
  value = google_cloudbuild_trigger.cloud-build-pipeline.name
}

output "worker-pool" {
  value = google_cloudbuild_worker_pool.pool.name
}