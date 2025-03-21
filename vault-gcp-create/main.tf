locals {
  project = "my-awesome-project"
}

resource "vault_gcp_secret_backend" "gcp" {
  path        = "gcp"
  credentials = file("credentials.json")
}

resource "vault_gcp_secret_roleset" "roleset" {
  backend      = vault_gcp_secret_backend.gcp.path
  roleset      = "project_viewer"
  secret_type  = "access_token"
  project      = local.project
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${local.project}"

    roles = [
      "roles/viewer",
    ]
  }
}