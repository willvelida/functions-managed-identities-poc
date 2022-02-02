@description('Name of the Function App')
param functionAppName string

@description('Location of the Function App')
param functionAppLocation string

@description('Name of the App Service Plan to deploy the Function App to')
param appServicePlanName string

@description('User Assigned Identities assigned to this Function')
param userAssignedIdentities object

@description('Name of the storage account for the Function')
param storageAccountName string

@description('The App Insights Instrumentation Key to use for this Function')
param appInsightsInstrumentationKey string

@description('Identity Resource Id for the Key Vault')
param keyVaultReferenceIdentity string

@description('Name of the key vault to add secrets to')
param keyVaultName string

param functionRuntime string = 'dotnet'

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: functionAppLocation
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsightsInstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
    keyVaultReferenceIdentity: keyVaultReferenceIdentity
  }
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: userAssignedIdentities
  }
}

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: functionAppLocation
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {  
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: functionAppLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

resource azureFilesConnectionSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${keyVaultName}/azurefilesconnectionstring'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
  }
}

output storageAccount object = storageAccount
