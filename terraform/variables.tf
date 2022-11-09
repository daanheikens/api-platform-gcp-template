variable "project_id" {
  type        = string
  description = "GCP Project ID"
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

variable "environment" {
  type        = string
  description = "Environment to run the application in. Can be dev, test, prod"
}

variable "debug_enabled" {
  type        = string
  description = "Whether debug logs are enabled"
}