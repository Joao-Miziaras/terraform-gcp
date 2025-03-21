provider "google" {
  project      = var.project_id
  credentials = base64decode(local.gcp_private_key)

}

provider "vault" {
  address = "http://54.89.170.216:8200"
}