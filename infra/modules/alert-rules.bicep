targetScope = 'resourceGroup'

@description('Azure region for alert rules.')
param location string

@description('Resource ID of the Log Analytics workspace.')
param logAnalyticsWorkspaceId string

@description('Resource ID of the Action Group.')
param actionGroupId string

@description('Name of the non-compliance alert rule.')
param nonComplianceAlertName string = 'alert-policy-noncompliance'

@description('Name of the policy activity alert rule.')
param policyActivityAlertName string = 'alert-policy-activity'

resource nonComplianceAlert 'Microsoft.Insights/scheduledQueryRules@2023-12-01' = {
  name: nonComplianceAlertName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'Triggers when non-compliant Azure Policy states are detected.'
    enabled: true
    severity: 2
    evaluationFrequency: 'PT15M'
    windowSize: 'PT15M'
    scopes: [
      logAnalyticsWorkspaceId
    ]
    targetResourceTypes: [
      'Microsoft.OperationalInsights/workspaces'
    ]
    criteria: {
      allOf: [
        {
          query: '''
arg("").PolicyResources
| where type =~ "microsoft.policyinsights/policystates"
| extend complianceState = tostring(properties.complianceState)
| where complianceState == "NonCompliant"
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 0
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
    autoMitigate: false
    actions: {
      actionGroups: [
        actionGroupId
      ]
    }
  }
}

resource policyActivityAlert 'Microsoft.Insights/scheduledQueryRules@2023-12-01' = {
  name: policyActivityAlertName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'Triggers when policy-related Azure Activity events are detected.'
    enabled: true
    severity: 3
    evaluationFrequency: 'PT15M'
    windowSize: 'PT15M'
    scopes: [
      logAnalyticsWorkspaceId
    ]
    targetResourceTypes: [
      'Microsoft.OperationalInsights/workspaces'
    ]
    criteria: {
      allOf: [
        {
          query: '''
AzureActivity
| where CategoryValue =~ "Policy"
| where OperationNameValue has "policy"
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 0
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
    autoMitigate: false
    actions: {
      actionGroups: [
        actionGroupId
      ]
    }
  }
}

output nonComplianceAlertId string = nonComplianceAlert.id
output policyActivityAlertId string = policyActivityAlert.id
output nonComplianceAlertPrincipalId string = nonComplianceAlert.identity.principalId
output policyActivityAlertPrincipalId string = policyActivityAlert.identity.principalId
