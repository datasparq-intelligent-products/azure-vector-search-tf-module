variable "algorithm_name" {
  type    = string
  default = "vs-algorithm"
}

variable "datasource_config" {
  default = {}
}

variable "datasource_name" {
  type    = string
  default = "vs-datasource"
}

variable "embedding_model_deployment_name" {
  type    = string
  default = "vs-model-deployment"
}

variable "embedding_model_name" {
  type    = string
  default = "text-embedding-ada-002"
}

variable "embedding_model_version" {
  type    = string
  default = "2"
}

variable "index_config" {
  default = {}
}

variable "indexer_config" {
  default = {}
}

variable "index_name" {
  type    = string
  default = "vs-index"
}

variable "indexer_name" {
  type    = string
  default = "vs-indexer"
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "openai_service_name" {
  type    = string
  default = "vs-openai"
}

variable "openai_service_sku" {
  type    = string
  default = "S0"
}

variable "profile_name" {
  type    = string
  default = "vs-profile"
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "search_service_api_version" {
  type    = string
  default = "2024-07-01"
}

variable "search_service_name" {
  type    = string
  default = "vs-search-service"
}

variable "search_service_sku" {
  type    = string
  default = "basic"
}

variable "semantic_config_name" {
  type    = string
  default = "vs-semantic-config"
}

variable "skillset_config" {
  default = {}
}

variable "skillset_name" {
  type    = string
  default = "vs-skillset"
}

variable "storage_account_name" {
  type    = string
  default = ""
}

variable "storage_container_name" {
  type    = string
  default = ""
}

variable "vectorizer_name" {
  type    = string
  default = "vs-vectorizer"
}