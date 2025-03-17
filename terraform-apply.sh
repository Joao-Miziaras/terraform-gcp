#!/bin/bash
CONFIG_FILE=".vault_credentials"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Arquivo de configuração '$CONFIG_FILE' não encontrado!"
    exit 1
fi

source "$CONFIG_FILE"

VAULT_TOKEN=$(curl -s --request POST --data "{\"role_id\":\"$APPROLE_ROLE_ID\", \"secret_id\":\"$APPROLE_SECRET_ID\"}" \
    "$VAULT_ADDR/v1/auth/approle/login" | jq -r '.auth.client_token')

if [[ -z "$VAULT_TOKEN" || "$VAULT_TOKEN" == "null" ]]; then
    echo "Falha na autenticação do Vault!"
    exit 1
fi

GCP_KEY_JSON=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/gcp/key/my-role" | jq -r '.data.private_key_data')

if [[ -z "$GCP_KEY_JSON" || "$GCP_KEY_JSON" == "null" ]]; then
    echo "Não foi possível obter a chave JSON da Service Account!"
    exit 1
fi

echo "$GCP_KEY_JSON" | base64 --decode > gcp-key.json
echo "Chave salva em gcp-key.json"

export TF_VAR_gcp_credentials_file="gcp-key.json"

echo "Executando Terraform"
terraform apply -var="project_id=vault-test-453619"
