targetScope = 'resourceGroup'

@description('Location for the workbook resource.')
param location string

@description('Name of the workbook.')
param workbookDisplayName string = 'Cloud Policy Compliance Dashboard'

@description('Resource ID of the Log Analytics workspace.')
param logAnalyticsWorkspaceId string

@description('Serialized workbook data JSON.')
param workbookData string

resource workbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: guid(workbookDisplayName, resourceGroup().id)
  location: location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    sourceId: logAnalyticsWorkspaceId
    category: 'workbook'
    serializedData: workbookData
  }
}

output workbookId string = workbook.id
output workbookName string = workbook.name
