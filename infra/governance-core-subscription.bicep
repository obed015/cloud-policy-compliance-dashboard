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

@description('Workbook display name.')
param workbookDisplayName string = 'Cloud Policy Compliance Dashboard'

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

module workbook './modules/workbook.bicep' = {
  name: 'deploy-workbook'
  scope: resourceGroup(governanceResourceGroup.name)
  params: {
    location: location
    workbookDisplayName: workbookDisplayName
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
    workbookData: loadTextContent('../workbooks/policy-dashboard.json')
  }
}

module alertRules './modules/alert-rules.bicep' = {
  name: 'deploy-alert-rules'
  scope: resourceGroup(governanceResourceGroup.name)
  params: {
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
    actionGroupId: actionGroup.outputs.actionGroupId
  }
}

output resourceGroupId string = governanceResourceGroup.id
output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
output actionGroupId string = actionGroup.outputs.actionGroupId
output workbookId string = workbook.outputs.workbookId
output nonComplianceAlertId string = alertRules.outputs.nonComplianceAlertId
output policyActivityAlertId string = alertRules.outputs.policyActivityAlertId
