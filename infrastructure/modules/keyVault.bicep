@description('Name for the Key Vault')
param keyVaultName string

@description('Location that the Key Vault will be provisioned to')
param keyVaultLocation string

@description('Name of the role assignment')
param roleNameGuid string

@description('Principal Id for the Role Assignment')
param principalId string

@description('Role Definition Id for the Key Vault Role Assignment')
param roleDefinitionId string

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: keyVaultLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
    ]
  }
}

resource kvRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: roleNameGuid
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
  }
  scope: keyVault
}
