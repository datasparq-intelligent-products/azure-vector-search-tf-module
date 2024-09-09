
locals {
  # Open AI service name must be globally unique, so append a random string to the default value (unless module caller has
  # supplied their own name, in which case use that)
  openai_service_name = var.openai_service_name == "vs-openai" ? "vs-openai-${random_string.r[0].result}" : var.openai_service_name
}

# Random string to append to default OpenAI service name
resource "random_string" "r" {
  count   = var.openai_service_name == "vs-openai" ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

# Blob storage account for which we are implementing vector search
data "azurerm_storage_account" "main" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

# Azure AI Search resource
resource "azurerm_search_service" "main" {
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.search_service_sku
}

# Azure OpenAI resource
resource "azurerm_cognitive_account" "main" {
  name                               = local.openai_service_name
  kind                               = "OpenAI"
  location                           = var.location
  custom_subdomain_name              = local.openai_service_name
  resource_group_name                = var.resource_group_name
  sku_name                           = var.openai_service_sku
  local_auth_enabled                 = true
  outbound_network_access_restricted = false
  public_network_access_enabled      = true
}

# Model deployment within OpenAI service which will be used to generate embeddings for documents & search queries
resource "azurerm_cognitive_deployment" "main" {
  cognitive_account_id   = azurerm_cognitive_account.main.id
  name                   = var.embedding_model_deployment_name
  version_upgrade_option = "NoAutoUpgrade"

  model {
    format  = "OpenAI"
    name    = var.embedding_model_name
    version = var.embedding_model_version
  }

  sku {
    name     = "Standard"
    capacity = 10
  }
}

# Azure AI Search index
resource "restapi_object" "index" {
  path         = "/indexes"
  query_string = "api-version=${var.search_service_api_version}"
  # If caller provides their own index config, use this, else use module default config
  data         = var.index_config != {} ? jsonencode(var.index_config) : jsonencode(local.index_config)
  id_attribute = "name"
}

# Azure AI Search indexer
resource "restapi_object" "indexer" {
  path         = "/indexers"
  query_string = "api-version=${var.search_service_api_version}"
  # If caller provides their own indexer config, use this, else use module default config
  data         = var.indexer_config != {} ? jsonencode(var.indexer_config) : jsonencode(local.indexer_config)
  id_attribute = "name"
  depends_on   = [restapi_object.skillset, restapi_object.datasource]
}

# Azure AI Search data source
resource "restapi_object" "datasource" {
  path         = "/datasources"
  query_string = "api-version=${var.search_service_api_version}"
  # If caller provides their own datasource config, use this, else use module default config
  data         = var.datasource_config != {} ? jsonencode(var.datasource_config) : jsonencode(local.datasource_config)
  id_attribute = "name"
}

# Azure AI Search skillset
resource "restapi_object" "skillset" {
  path         = "/skillsets"
  query_string = "api-version=${var.search_service_api_version}"
  # If caller provides their own skillset config, use this, else use module default config
  data         = var.skillset_config != {} ? jsonencode(var.skillset_config) : jsonencode(local.skillset_config)
  id_attribute = "name"
  depends_on   = [restapi_object.index]
}