output "db-instance" {
  value = google_sql_database_instance.pg-database-instance
}

output "database-ip" {
  value = google_sql_database_instance.pg-database-instance.ip_address[0].ip_address
}