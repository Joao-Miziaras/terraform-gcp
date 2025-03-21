
data "http" "vault_request" {
  url = "http://54.89.170.216:8200/v1/gcp/key/nova-role"
  insecure = true

  request_headers = {
    "X-Vault-Token" =  vault_approle_auth_backend_login.vault_auth.client_token
  }
}