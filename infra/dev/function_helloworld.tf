resource "azurerm_storage_account" "functions" {
  name                     = "${var.owner}${var.application_name}${var.environment_name}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_user_assigned_identity" "functions" {
  location            = azurerm_resource_group.main.location
  name                = "mi-${var.owner}-${var.application_name}-${var.environment_name}-fn"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_service_plan" "main" {
  name                = "example-app-service-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "helloworld" {
  name                = "func-${var.owner}-${var.application_name}-${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = "20"
    }
    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = true
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 1
    "APPINSIGHT_INSTRUMENTATIONKEY" = azurerm_application_insights.main.instrumentation_key
  }

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.functions.id]
  }
}