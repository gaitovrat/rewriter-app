resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.project_name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "B1"
  os_type             = "Linux"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.asp.id
  tags                = var.tags

  site_config {
    always_on        = true
    application_stack {
      docker_image_name = "ghcr.io/gaitovrat/rewriter-app:0.1.0"
    }
    cors {
      allowed_origins = ["*"]
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    AZURE_API_ENDPOINT = "https://germanywestcentral.api.cognitive.microsoft.com/"
    AZURE_API_KEY = azurerm_key_vault_secret.openai_key.value
    AZURE_API_VERSION = "2025-01-01-preview"
    AZURE_DEPLOYMENT = "rewriter-gpt-4o-mini-2024-07-18"
  }

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
}
