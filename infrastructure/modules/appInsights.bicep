@description('Location to deploy the App Insights instance')
param location string

@description('Name of the App Insights Instance')
param appInsightsName string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
