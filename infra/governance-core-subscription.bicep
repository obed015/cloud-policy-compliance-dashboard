targetScope = 'subscription'

@description('Azure region for governance resources.')
param location string = 'uksouth'

@description('Name of the governance resource group.')
param resourceGroupName string = 'rg-governance-core'

@description('Name of the Log Analytics workspace.')
param logAnalyticsWorkspaceName string = 'law-governance-core'

@description('Name of the Action Group.')
param actionGroupName string = 'ag-governance-core'

@description('Short name for the Action Group.')
@maxLength(12)
param actionGroupShortName string = 'govcore'

@description('Email address to receive governance alerts.')
param alertEmailAddress string

resource governanceResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

module logAnalytics './modules/log-analytics.bicep' = {
  name: 'deploy-log-analytics'
  scope: resourceGroup(governanceResourceGroup.name)
  params: {
    workspaceName: logAnalyticsWorkspaceName
    location: location
  }
}

module actionGroup './modules/action-group.bicep' = {
  name: 'deploy-action-group'
  scope: resourceGroup(governanceResourceGroup.name)
  params: {
    actionGroupName: actionGroupName
    shortName: actionGroupShortName
    alertEmailAddress: alertEmailAddress
  }
}

output resourceGroupId string = governanceResourceGroup.id
output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
output actionGroupId string = actionGroup.outputs.actionGroupId
