#!/bin/bash
RG_STATE="rg-secops-mgmt-germanywestcentral"
LOCATION="germanywestcentral"

# Génération d'un nom unique avec un hash court
UNIQUE_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)
STORAGE_NAME="stsecopsstate${UNIQUE_ID}"
CONTAINER_NAME="tfstate"

# 2. Création du Resource Group dédié au State
az group create --name $RG_STATE --location $LOCATION

# 3. Création du compte de stockage durci (TLS 1.2 forcé, chiffrement au repos standard)
az storage account create \
  --name $STORAGE_NAME \
  --resource-group $RG_STATE \
  --location $LOCATION \
  --sku Standard_LRS \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

# 4. Création du conteneur de blobs privé
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_NAME \
  --auth-mode login