@description('Name of the User Managed Identity')
param userManagedIdentityName string

@description('Location of the User Managed Identity')
param userManagedIdentityLocation string

resource managedIdentites 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userManagedIdentityName
  location: userManagedIdentityLocation
}

output principalId string = managedIdentites.properties.principalId
output resourceId string = managedIdentites.id

