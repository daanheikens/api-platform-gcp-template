variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "project" {
  type        = string
  description = "Prefix for resources"
}

variable "region" {
  type        = string
  description = "Region where to deploy the application"
}

variable "github_repository" {
  type = object({
    owner : string
    repository : string
  })
  description = "Owner and repository name of which code should be deployed to Cloud Run"
}

variable "database_ip" {
  type        = string
  description = "IP address of the Database instance used to run migration scripts"
}