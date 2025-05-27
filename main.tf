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
resource "azurerm_storage_account" "jaiterrastorage1" {
  name = "jaiterrastorage1"
  account_tier = "Standard"
  account_replication_type = "LRS"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  
}
resource "azurerm_storage_account" "jaiterrastorage2" {
  name = "jaiterrastorage2"
  account_tier = "Standard"
  account_replication_type = "LRS"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  
}

resource "azurerm_service_plan" "svcplan" {
resource_group_name = azurerm_resource_group.rg.name
name = "appplan"
location = azurerm_resource_group.rg.location
sku_name = "SHARED"
os_type = "Linux"
}


resource "azurerm_linux_web_app" "appsvc" {
  name                = "linuxappjaimin"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.svcplan.id
  site_config {
    http2_enabled = alltrue()
  }
}


