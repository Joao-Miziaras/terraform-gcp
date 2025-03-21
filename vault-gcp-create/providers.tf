provider "vault" {
  address = "http://54.89.170.216:8200"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
  }
}