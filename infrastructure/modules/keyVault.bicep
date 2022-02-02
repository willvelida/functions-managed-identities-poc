@description('Name for the Key Vault')
param keyVaultName string

@description('Location that the Key Vault will be provisioned to')
param keyVaultLocation string

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
