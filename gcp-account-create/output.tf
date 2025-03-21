# 🔹 Outputs para exibir a SA e a chave privada
output "service_account_email" {
  value = google_service_account.sa.email
}

output "private_key" {
  value     = google_service_account_key.sa_key.private_key
  sensitive = true
}

output "vault_response" {
  value = jsondecode(data.http.vault_request.response_body)
}
