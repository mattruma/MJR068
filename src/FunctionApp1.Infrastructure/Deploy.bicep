param resourcePrefix string
param servicePrincipalId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: '${resourcePrefix}st'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
}

resource storageAccount_ContainerCollections 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccount.name}/collections'
}

resource keyVault 'Microsoft.KeyVault/vaults@2016-10-01' = {
  name: '${resourcePrefix}-kv'
  location: resourceGroup().location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: servicePrincipalId
        permissions: {
          keys: [
            'get'
            'create'
            'delete'
            'list'
            'update'
            'import'
            'backup'
            'restore'
            'recover'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'backup'
            'restore'
            'recover'
          ]
          certificates: [
            'get'
            'list'
            'delete'
            'create'
            'import'
            'update'
            'managecontacts'
            'getissuers'
            'listissuers'
            'setissuers'
            'deleteissuers'
            'manageissuers'
            'recover'
          ]
          storage: [
            'get'
            'list'
            'delete'
            'set'
            'update'
            'regeneratekey'
            'setsas'
            'listsas'
            'getsas'
            'deletesas'
          ]
        }
      }
    ]
    enabledForDeployment: false
    enableSoftDelete: true
  }
}

resource keyVaultName_StorageConnectionString1 'Microsoft.KeyVault/vaults/secrets@2016-10-01' = {
  name: '${keyVaultName.name}/StorageConnectionString1'
  location: resourceGroup().location
  properties: {
    attributes: {
      enabled: true
    }
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listKeys(storageAccountName.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value};EndpointSuffix=core.windows.net'
  }
}

resource functionAppServerFarmName 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: functionAppServerFarmName_var
  location: 'East US'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource functionAppStorageAccountName 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: functionAppStorageAccountName_var
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
}

resource functionAppApplicationInsightsName 'microsoft.insights/components@2018-05-01-preview' = {
  name: functionAppApplicationInsightsName_var
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'IbizaWebAppExtensionCreate'
    RetentionInDays: 90
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource functionAppName 'Microsoft.Web/sites@2018-11-01' = {
  name: functionAppName_var
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    enabled: true
    serverFarmId: resourceId(resourceGroup().name, 'Microsoft.Web/serverFarms', functionAppServerFarmName_var)
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccountName_var};AccountKey=${listKeys(functionAppStorageAccountName.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccountName_var};AccountKey=${listKeys(functionAppStorageAccountName.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: concat(functionAppName_var)
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~12'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('microsoft.insights/components/${functionAppApplicationInsightsName_var}').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference('microsoft.insights/components/${functionAppApplicationInsightsName_var}').ConnectionString
        }
      ]
    }
  }
  dependsOn: [
    functionAppServerFarmName

    functionAppApplicationInsightsName
  ]
}

resource keyVaultName_FunctionApp1Code 'Microsoft.KeyVault/vaults/secrets@2016-10-01' = {
  name: '${keyVaultName.name}/FunctionApp1Code'
  location: resourceGroup().location
  properties: {
    attributes: {
      enabled: true
    }
    value: listkeys('${functionAppId}/host/default', '2018-11-01').functionKeys.default
  }
}
