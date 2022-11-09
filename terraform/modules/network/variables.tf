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