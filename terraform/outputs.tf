output "database-private-ip" {
  value = module.sql.database-ip
}

output "cloud-builder-worker-pool" {
  value = module.ci-cd.worker-pool
}

output "cloud-run-url" {
  value = "${google_cloud_run_service.run-service.status[0].url}/api/cars"
}