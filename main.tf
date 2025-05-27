terraform {
 required_version = ">=1.3.7"
 required_providers {
   azurerm = {
   source = "hashicorp/azurerm"
   version = "~>3.43.0"
}
 }

  cloud { 
    
    organization = "Bioref" 

    workspaces { 
      name = "terraformci" 
    } 
  } 
}

 

provider "azurerm" {
features {
}
skip_provider_registration = true 
}
resource "azurerm_resource_group" "rg" {
 name = "1-d894c370-playground-sandbox"
 location = "West US" 
 }
resource "azurerm_storage_account" "storage" {
  name = "jaiterrastorage1"
  account_tier = "Standard"
  account_replication_type = "LRS"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  
}
