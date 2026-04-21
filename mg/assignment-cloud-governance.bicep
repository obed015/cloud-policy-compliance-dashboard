targetScope = 'managementGroup'

@description('Name of the policy assignment.')
param assignmentName string = 'asg-cloud-gov-base'

@description('Display name shown in Azure Policy.')
param assignmentDisplayName string = 'Assign Cloud Governance Baseline'

@description('Description for the policy assignment.')
param assignmentDescription string = 'Assigns the Cloud Governance Baseline initiative at the management group scope with remediation support.'

@description('Resource ID of the initiative to assign.')
param initiativeDefinitionId string

resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2025-03-01' = {
  name: assignmentName
  location: 'uksouth'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: assignmentDisplayName
    description: assignmentDescription
    policyDefinitionId: initiativeDefinitionId
    enforcementMode: 'Default'
    parameters: {}
  }
}

output assignmentId string = initiativeAssignment.id
output assignmentNameOut string = initiativeAssignment.name
output assignmentPrincipalId string = initiativeAssignment.identity.principalId
