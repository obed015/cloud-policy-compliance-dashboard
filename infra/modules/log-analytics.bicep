targetScope = 'resourceGroup'

@description('Name of the Log Analytics workspace.')
param workspaceName string

@description('Azure region for the workspace.')
param location string

@description('Number of days to retain logs.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 30

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

output workspaceId string = logAnalyticsWorkspace.id
output workspaceNameOut string = logAnalyticsWorkspace.name
