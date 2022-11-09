terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

provider "random" {

}

locals {
  project = "api-platform"
}

module "ci-cd" {
  source            = "./modules/ci-cd"
  project           = local.project
  project_id        = var.project_id
  region            = var.region
  github_repository = var.github_repository
  database_ip       = module.sql.database-ip

  depends_on = [
    module.network
  ]
}

module "network" {
  source     = "./modules/network"
  project    = local.project
  project_id = var.project_id
  region     = var.region
}

module "sql" {
  source     = "./modules/sql"
  project    = local.project
  project_id = var.project_id
  region     = var.region

  depends_on = [
    module.network
  ]
}
