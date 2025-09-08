resource "azurerm_cognitive_account" "openai" {
  name                = "${var.project_name}-openai"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
}

resource "azurerm_cognitive_deployment" "openai_deploy" {
  name                 = "${var.project_name}-${var.openai_model_name}-${var.openai_model_version}"
  cognitive_account_id = azurerm_cognitive_account.openai.id


  model {
    name    = var.openai_model_name
    version = var.openai_model_version
    format  = "OpenAI"
  }

  sku {
    name     = var.openai_model_sku_name
    capacity = 1
  }
}
