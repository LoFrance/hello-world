
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.owner}-${var.environment_name}"
  location = var.location
}