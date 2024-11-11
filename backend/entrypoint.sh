#!/bin/bash

SECRET_DATA_BACKEND=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" http://$VAULT_IP:8200/v1/secret/data/backend)
SECRET_DATA_POSTGRES=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" http://$VAULT_IP:8200/v1/secret/data/data/postgres)

export SECRET_KEY=$(echo $SECRET_DATA_BACKEND | jq -r '.data.data.SECRET_KEY')
export FIRST_SUPERUSER=$(echo $SECRET_DATA_BACKEND | jq -r '.data.data.FIRST_SUPERUSER')
export FIRST_SUPERUSER_PASSWORD=$(echo $SECRET_DATA_BACKEND | jq -r '.data.data.FIRST_SUPERUSER_PASSWORD')
export USERS_OPEN_REGISTRATION=$(echo $SECRET_DATA_BACKEND | jq -r '.data.data.USERS_OPEN_REGISTRATION')

export POSTGRES_DB=$(echo $SECRET_DATA_POSTGRES | jq -r '.data.data.POSTGRES_DB')
export POSTGRES_USER=$(echo $SECRET_DATA_POSTGRES | jq -r '.data.data.POSTGRES_USER')
export POSTGRES_PASSWORD=$(echo $SECRET_DATA_POSTGRES | jq -r '.data.data.POSTGRES_PASSWORD')

poetry run bash ./prestart.sh && poetry run uvicorn app.main:app --host 0.0.0.0 --reload
