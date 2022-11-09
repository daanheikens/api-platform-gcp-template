# Copy this file as: terraform.tfvars

project_id = "<GCP_PROJECT_ID>"
region     = "<GCP_REGION>"
github_repository = {
  owner      = "<GITHUB_USER>"
  repository = "<GITHUB_REPOSITORY>"
}
# ENV variables for Cloud Run
environment   = "prod"
debug_enabled = false