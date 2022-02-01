param keyVaultName string
param keyVaultUserIdentityName string
param location string = resourceGroup().location
param roleNameGuid string = newGuid()

module keyVault 'modules/keyVault.bicep' = {
  name: 'keyVault'
  params: {
    keyVaultLocation: location
    keyVaultName: keyVaultName
    roleNameGuid: roleNameGuid
    principalId: keyVaultUserIdentity.outputs.principalId
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6'
  }
}

module keyVaultUserIdentity 'modules/userManagedIdentities.bicep' = {
  name: 'keyVaultUserManagedIndentity'
  params: {
    userManagedIdentityLocation: location
    userManagedIdentityName: keyVaultUserIdentityName
  }
}
