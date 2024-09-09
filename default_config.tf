/*

Default configs for Azure Search Service sub-resources:

- Data Source
- Index
- Indexer
- Skillset

To customise one or more of these configs, copy what you need from the below into your own Terraform module,
make the required changes and then pass the config back into this module using the relevant module variable(s):

- var.datasource_config
- var.index_config
- var.indexer_config
- var.skillset_config

*/

locals {

  datasource_config = {
    name        = var.datasource_name
    description = null
    type        = "azureblob"
    subtype     = null
    credentials = {
      connectionString = data.azurerm_storage_account.main.primary_connection_string
    }
    container = {
      name  = var.storage_container_name
      query = null
    }
    dataChangeDetectionPolicy   = null
    dataDeletionDetectionPolicy = null
    encryptionKey               = null
  }

  index_config = {
    name                  = var.index_name
    defaultScoringProfile = null
    fields = [
      {
        name                = "chunk_id"
        type                = "Edm.String"
        searchable          = true
        filterable          = true
        retrievable         = true
        stored              = true
        sortable            = true
        facetable           = true
        key                 = true
        indexAnalyzer       = null
        searchAnalyzer      = null
        analyzer            = "keyword"
        dimensions          = null
        vectorSearchProfile = null
        vectorEncoding      = null
        synonymMaps         = []
      },
      {
        name                = "parent_id"
        type                = "Edm.String"
        searchable          = true
        filterable          = true
        retrievable         = true
        stored              = true
        sortable            = true
        facetable           = true
        key                 = false
        indexAnalyzer       = null
        searchAnalyzer      = null
        analyzer            = null
        dimensions          = null
        vectorSearchProfile = null
        vectorEncoding      = null
        synonymMaps         = []
      },
      {
        name                = "chunk"
        type                = "Edm.String"
        searchable          = true
        filterable          = false
        retrievable         = true
        stored              = true
        sortable            = false
        facetable           = false
        key                 = false
        indexAnalyzer       = null
        searchAnalyzer      = null
        analyzer            = null
        dimensions          = null
        vectorSearchProfile = null
        vectorEncoding      = null
        synonymMaps         = []
      },
      {
        name                = "title"
        type                = "Edm.String"
        searchable          = true
        filterable          = true
        retrievable         = true
        stored              = true
        sortable            = false
        facetable           = false
        key                 = false
        indexAnalyzer       = null
        searchAnalyzer      = null
        analyzer            = null
        dimensions          = null
        vectorSearchProfile = null
        vectorEncoding      = null
        synonymMaps         = []
      },
      {
        name                = "metadata_storage_path"
        type                = "Edm.String"
        searchable          = true
        filterable          = false
        retrievable         = true
        stored              = true
        sortable            = false
        facetable           = false
        key                 = false
        indexAnalyzer       = null
        searchAnalyzer      = null
        analyzer            = null
        dimensions          = null
        vectorSearchProfile = null
        vectorEncoding      = null
        synonymMaps         = []
      },
      {
        name                = "text_vector"
        type                = "Collection(Edm.Single)"
        searchable          = true
        filterable          = false
        retrievable         = true
        stored              = true
        sortable            = false
        facetable           = false
        key                 = false
        indexAnalyzer       = null
        searchAnalyzer      = null
        analyzer            = null
        dimensions          = 1536
        vectorSearchProfile = var.profile_name
        vectorEncoding      = null
        synonymMaps         = []
      }
    ]
    scoringProfiles = []
    corsOptions     = null
    suggesters      = []
    analyzers       = []
    tokenizers      = []
    tokenFilters    = []
    charFilters     = []
    encryptionKey   = null
    similarity = {
      "@odata.type" = "#Microsoft.Azure.Search.BM25Similarity"
      k1            = null
      b             = null
    }
    semantic = {
      defaultConfiguration = var.semantic_config_name
      configurations = [
        {
          name = var.semantic_config_name
          prioritizedFields = {
            titleField = {
              fieldName = "title"
            }
            prioritizedContentFields = [
              {
                fieldName = "chunk"
              }
            ]
            prioritizedKeywordsFields = []
          }
        }
      ]
    }
    vectorSearch = {
      algorithms = [
        {
          name = var.algorithm_name
          kind = "hnsw"
          hnswParameters = {
            metric         = "cosine"
            m              = 4
            efConstruction = 400
            efSearch       = 500
          }
          exhaustiveKnnParameters = null
        }
      ]
      profiles = [
        {
          name        = var.profile_name
          algorithm   = var.algorithm_name
          vectorizer  = var.vectorizer_name
          compression = null
        }
      ]
      vectorizers = [
        {
          name = var.vectorizer_name
          kind = "azureOpenAI"
          azureOpenAIParameters = {
            resourceUri  = azurerm_cognitive_account.main.endpoint
            deploymentId = var.embedding_model_deployment_name
            apiKey       = azurerm_cognitive_account.main.primary_access_key
            modelName    = var.embedding_model_name
            authIdentity = null
          }
        }
      ]
      compressions = []
    }
  }

  indexer_config = {
    name            = var.indexer_name
    description     = null
    dataSourceName  = var.datasource_name
    skillsetName    = var.skillset_name
    targetIndexName = var.index_name
    disabled        = null
    schedule        = null
    parameters = {
      batchSize              = null
      maxFailedItems         = null
      maxFailedItemsPerBatch = null
      base64EncodeKeys       = null
      configuration = {
        dataToExtract = "contentAndMetadata"
        parsingMode   = "default"
      }
    }
    fieldMappings = [
      {
        sourceFieldName = "metadata_storage_name"
        targetFieldName = "title"
        mappingFunction = null
      }
    ]
    outputFieldMappings = []
  }

  skillset_config = {
    name        = var.skillset_name
    description = "Skillset to chunk documents and generate embeddings"
    skills = [
      {
        "@odata.type"       = "#Microsoft.Skills.Text.SplitSkill"
        name                = "#1"
        description         = "Split skill to chunk documents"
        context             = "/document"
        defaultLanguageCode = "en"
        textSplitMode       = "pages"
        maximumPageLength   = 2000
        pageOverlapLength   = 500
        maximumPagesToTake  = 0
        inputs = [
          {
            name   = "text"
            source = "/document/content"
          }
        ]
        outputs = [
          {
            name       = "textItems"
            targetName = "pages"
          }
        ]
      },
      {
        "@odata.type" = "#Microsoft.Skills.Text.AzureOpenAIEmbeddingSkill"
        name          = "#2"
        description   = "Embedding skill"
        context       = "/document/pages/*"
        resourceUri   = azurerm_cognitive_account.main.endpoint
        apiKey        = azurerm_cognitive_account.main.primary_access_key
        deploymentId  = var.embedding_model_deployment_name
        dimensions    = 1536
        modelName     = var.embedding_model_name
        inputs = [
          {
            name   = "text"
            source = "/document/pages/*"
          }
        ]
        outputs = [
          {
            name       = "embedding"
            targetName = "text_vector"
          }
        ]
        authIdentity = null
      }
    ]
    cognitiveServices = null
    knowledgeStore    = null
    indexProjections = {
      selectors = [
        {
          targetIndexName    = var.index_name
          parentKeyFieldName = "parent_id"
          sourceContext      = "/document/pages/*"
          mappings = [
            {
              name          = "text_vector"
              source        = "/document/pages/*/text_vector"
              sourceContext = null
              inputs        = []
            },
            {
              name          = "chunk"
              source        = "/document/pages/*"
              sourceContext = null
              inputs        = []
            },
            {
              name          = "metadata_storage_path"
              source        = "/document/metadata_storage_path"
              sourceContext = null
              inputs        = []
            },
            {
              name          = "title"
              source        = "/document/title"
              sourceContext = null
              inputs        = []
            }
          ]
        }
      ]
      parameters = {
        projectionMode = "skipIndexingParentDocuments"
      }
    }
    encryptionKey = null
  }
}
