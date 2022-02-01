@description('Name of the Function App')
param functionAppName string

@description('Location of the Function App')
param functionAppLocation string

@description('Name of the App Service Plan to deploy the Function App to')
param appServicePlanName string

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: functionAppLocation
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      
    }
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
