@description('Name of the Service Bus instance')
param serviceBusName string

@description('Location that the Service Bus will be deployed to')
param serviceBusLocation string

@description('Name of the queue that we want to provision in our service bus')
param queueName string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: serviceBusName
  location: serviceBusLocation
  sku: {
    name: 'Basic'
  }

  resource queue 'queues' = {
    name: queueName
  }
}
