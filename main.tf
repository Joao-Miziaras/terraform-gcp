terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

variable "project_id" {
  description = "ID do projeto no GCP"
  type        = string
}

provider "google" {
  project      = var.project_id
}

variable "service_account_name" {
  description = "Nome da Service Account"
  type        = string
  default     = "my-service-account"
}

variable "service_account_roles" {
  description = "Lista de roles para atribuir à Service Account"
  type        = list(string)
  default     = ["roles/viewer"]
}

resource "google_service_account" "sa" {
  account_id   = var.service_account_name
  display_name = "Service Account criada pelo Terraform"
}

resource "google_project_iam_binding" "sa_roles" {
  for_each = toset(var.service_account_roles)

  project = var.project_id
  role    = each.key

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
  key_algorithm      = "KEY_ALG_RSA_2048"
}

output "service_account_email" {
  value = google_service_account.sa.email
}

output "private_key" {
  value     = google_service_account_key.sa_key.private_key
  sensitive = true
}