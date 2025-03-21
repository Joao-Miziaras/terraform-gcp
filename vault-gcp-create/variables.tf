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

variable "project_id" {
  description = "ID do projeto no GCP"
  type        = string
  default     = "vault-test-453619"
}

variable "role_id" {
  description = "Role ID for Vault AppRole login"
  type        = string
}

variable "secret_id" {
  description = "Secret ID for Vault AppRole login"
  type        = string
}
