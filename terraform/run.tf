resource "google_cloud_run_service" "run-service" {
  name     = "${local.project}-run"
  location = var.region

  template {
    spec {
      containers {
        image = "europe-west4-docker.pkg.dev/${var.project_id}/${local.project}/api"
        ports {
          protocol       = "TCP"
          container_port = 8080
        }

        env {
          name  = "DATABASE_URL"
          value = "postgresql://app:app@${module.sql.db-instance.ip_address[0].ip_address}:5432/app?serverVersion=14&charset=utf8"
        }

        env {
          name  = "APP_ENV"
          value = var.environment
        }

        env {
          name  = "APP_DEBUG"
          value = var.debug_enabled
        }
      }
      service_account_name = google_service_account.run-service-account.email
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "10"
        "autoscaling.knative.dev/minScale"        = "1"
        "run.googleapis.com/cloudsql-instances"   = module.sql.db-instance.connection_name
        "run.googleapis.com/vpc-access-connector" = module.network.serverless-connector
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
      }
    }
  }

  metadata {
    labels = {
      gcb-trigger-id : module.ci-cd.cloud-build-trigger
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    module.ci-cd,
    module.sql,
    module.network
  ]
}

data "google_iam_policy" "cloud-run-iam-roles" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "cloud-run-iam-policy" {
  location = google_cloud_run_service.run-service.location
  project  = google_cloud_run_service.run-service.project
  service  = google_cloud_run_service.run-service.name

  policy_data = data.google_iam_policy.cloud-run-iam-roles.policy_data
}

resource "google_service_account" "run-service-account" {
  account_id = "${local.project}-run-sa"
}

resource "google_project_iam_member" "cloud-sql-client" {
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.run-service-account.email}"
  project = var.project_id
}