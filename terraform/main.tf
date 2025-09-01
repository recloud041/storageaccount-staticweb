terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100" # or latest you use
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50" # latest AzureAD provider
    }
  }
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}


# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-static-website"
  location = "East US"
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "staticwebsatya01" # must be globally unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "website" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = "index.html"
  error_404_document = "error.html"
}

data "azuread_service_principal" "ado_sp" {
  display_name = "ado-aks-deployer"
}

resource "azurerm_role_assignment" "blob_contrib" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_service_principal.ado_sp.id
}