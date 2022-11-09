resource "random_id" "db-suffix" {
  byte_length = 4
}

# Using the default network for demo purposes
data "google_compute_network" "default" {
  name = "default"
}

resource "google_sql_database_instance" "pg-database-instance" {
  name   = "${var.project}-pgsql-${random_id.db-suffix.hex}"
  region = var.region

  database_version = "POSTGRES_14"

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.default.id
    }
  }
  # For demo purposes to delete the application after the session. Typically you want to have this on true
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "app"
  instance = google_sql_database_instance.pg-database-instance.name
}

# WARNING!
#
# Plaintext credentials are solely here for demo purposes.
# Using plaintext credentials is unsafe. Do not use this for real world use-cases.
#
resource "google_sql_user" "database-user" {
  instance = google_sql_database_instance.pg-database-instance.name
  name     = "app"
  password = "app"
}