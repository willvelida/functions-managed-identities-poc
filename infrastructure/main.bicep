param keyVaultName string
param keyVaultUserIdentityName string
param location string = resourceGroup().location
param roleNameGuid string = newGuid()
param appServicePlanName string
param functionAppName string
param storageAccountName string
param appInsightsName string
param serviceBusName string
param queueName string

module keyVault 'modules/keyVault.bicep' = {
  name: 'keyVault'
  params: {
    keyVaultLocation: location
    keyVaultName: keyVaultName
  }
}

resource kvRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' existing = {
  name: roleNameGuid
}

module keyVaultUserIdentity 'modules/userManagedIdentities.bicep' = {
  name: 'keyVaultUserManagedIndentity'
  params: {
    userManagedIdentityLocation: location
    userManagedIdentityName: keyVaultUserIdentityName
  }
}

module appInsights 'modules/appInsights.bicep' = {
  name: 'appInsights'
  params: {
    appInsightsName: appInsightsName
    location: location
  }
}

resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

module functionApp 'modules/function.bicep' = {
  name: 'functionApp'
  params: {
    appInsightsInstrumentationKey: appInsights.outputs.appInsightsInstrumentationKey
    appServicePlanName: appServicePlanName
    functionAppLocation: location
    functionAppName: functionAppName
    storageAccountName: storageAccountName
    userAssignedIdentities: {
      '${keyVaultUserIdentity.outputs.resourceId}' : {}
    }
    keyVaultReferenceIdentity: keyVaultUserIdentity.outputs.resourceId
    keyVaultName: kv.name
    serviceBusName: serviceBusName
  }
}

module serviceBus 'modules/serviceBus.bicep' = {
  name: 'serviceBus'
  params: {
    queueName: queueName
    serviceBusLocation: location
    serviceBusName: serviceBusName
  }
}
