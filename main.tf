terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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
  name     = "1-d894c370-playground-sandbox"
  location = "West US"
}
resource "azurerm_storage_account" "jaiterrastorage1" {
  name                     = "jaiterrastorage1"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

}
resource "azurerm_storage_account" "jaiterrastorage3" {
  name                     = "jaiterrastorage3"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

}

resource "azurerm_service_plan" "svcplan" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "appplan"
  location            = azurerm_resource_group.rg.location
  sku_name            = "B1"
  os_type             = "Linux"
}


resource "azurerm_linux_web_app" "appsvc" {
  name                = "linuxappjaimin"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.svcplan.id
  site_config {
    http2_enabled = true
  }
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group provided by the lab."
}

variable "prefix" {
  type        = string
  description = "Prefix to be used for all resources in this lab."
}



data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_container_group" "main" {
  name                = "${var.prefix}-container-group"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.prefix}-container-group"
  os_type             = "Linux"
  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

output "dns_hostname" {
  value = azurerm_container_group.main.fqdn
}
