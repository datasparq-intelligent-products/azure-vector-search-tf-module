variable "ai_search_api_version" {
  type        = string
  default     = "2024-07-01"
  description = "API version used to create AI Search sub-resources (data source, index, indexer and skillset). Changing this will likely break this module."
}

variable "ai_search_name" {
  type        = string
  default     = "vs-search-service"
  description = "Name to give AI Search resource created by this module"
}

variable "ai_search_sku" {
  type        = string
  default     = "basic"
  description = "AI Search SKU - this has a direct effect on performance / cost"
}

variable "algorithm_name" {
  type        = string
  default     = "vs-algorithm"
  description = "Name to give vector search algorithm resource created by this module"
}

variable "datasource_config" {
  default     = {}
  description = "Variable to enable override of the default data source config created by this module"
}

variable "datasource_name" {
  type        = string
  default     = "vs-datasource"
  description = "Name to give to data source resource created by this module"
}

variable "embedding_model_deployment_name" {
  type        = string
  default     = "vs-model-deployment"
  description = "Name to give embedding model deployment resource created by this module"
}

variable "embedding_model_name" {
  type        = string
  default     = "text-embedding-ada-002"
  description = "Model to generate embeddings with - must be one of text-embedding-ada-002, text-embedding-3-large, text-embedding-3-small"
}

variable "embedding_model_version" {
  type        = string
  default     = "2"
  description = "Version of model to generate embeddings with - must be an available version of `embedding_model_name`"
}

variable "index_config" {
  default     = {}
  description = "Variable to enable override of the default index config created by this module"
}

variable "indexer_config" {
  default     = {}
  description = "Variable to enable override of the default indexer config created by this module"
}

variable "index_name" {
  type        = string
  default     = "vs-index"
  description = "Name to give index resource created by this module"
}

variable "indexer_name" {
  type        = string
  default     = "vs-indexer"
  description = "Name to give indexer resource created by this module"
}

variable "location" {
  type        = string
  default     = "UK South"
  description = "Azure location in which to create all resources"
}

variable "openai_service_name" {
  type        = string
  default     = "vs-openai"
  description = "Name to give OpenAI Service resource created by this module"
}

variable "openai_service_sku" {
  type        = string
  default     = "S0"
  description = "OpenAI Service SKU - this has a direct effect on performance / cost"
}

variable "profile_name" {
  type        = string
  default     = "vs-profile"
  description = "Name to give vector profile resource created by this module"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which to create all resources"
}

variable "semantic_config_name" {
  type        = string
  default     = "vs-semantic-config"
  description = "Name to give semantic config resource created by this module"
}

variable "skillset_config" {
  default     = {}
  description = "Variable to enable override of the default indexer config created by this module"
}

variable "skillset_name" {
  type        = string
  default     = "vs-skillset"
  description = "Name to give skillset resource created by this module"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account which contains data to index"
}

variable "storage_container_name" {
  type        = string
  description = "Storage container which contains data to index"
}

variable "vectorizer_name" {
  type        = string
  default     = "vs-vectorizer"
  description = "Name to give vectorizer resource created by this module"
}