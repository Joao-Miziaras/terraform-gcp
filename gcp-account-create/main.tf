terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "4.7.0"
    }
  }
}
locals {
  vault_response = jsondecode(data.http.vault_request.response_body)
  gcp_private_key = local.vault_response["data"]["private_key_data"]
}

resource "vault_approle_auth_backend_login" "vault_auth" {
  role_id   = var.role_id
  secret_id = var.secret_id
}

# 🔹 Criar uma Service Account no GCP
resource "google_service_account" "sa" {
  account_id   = var.service_account_name
  display_name = "Service Account criada pelo Terraform"
}
# 🔹 Atribuir permissões à Service Account
resource "google_project_iam_binding" "sa_roles" {
  for_each = toset(var.service_account_roles)

  project = var.project_id
  role    = each.key

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}
# 🔹 Criar chave privada para a Service Account
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
  key_algorithm      = "KEY_ALG_RSA_2048"
}

