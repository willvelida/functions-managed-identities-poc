param keyVaultName string
param keyVaultUserIdentityName string
param location string = resourceGroup().location
param roleNameGuid string = newGuid()
param appServicePlanName string
param functionAppName string
param storageAccountName string
param appInsightsName string

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
    keyVaultName: keyVaultName
  }
}
