targetScope = 'managementGroup'

@description('Name of the initiative definition.')
param initiativeName string = 'cloud-governance-baseline'

@description('Display name shown in Azure Policy.')
param initiativeDisplayName string = 'Cloud Governance Baseline'

@description('Description for the initiative.')
param initiativeDescription string = 'Groups governance policies for platform-wide Azure compliance.'

@description('Resource ID of the custom public network access policy definition.')
param publicNetworkPolicyDefinitionId string

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2025-03-01' = {
  name: initiativeName
  properties: {
    policyType: 'Custom'
    displayName: initiativeDisplayName
    description: initiativeDescription
    metadata: {
      category: 'Governance'
      version: '1.0.0'
    }
    parameters: {}
    policyDefinitions: [
      {
        policyDefinitionId: publicNetworkPolicyDefinitionId
        policyDefinitionReferenceId: 'auditStoragePublicNetworkAccess'
      }
    ]
  }
}

output initiativeDefinitionId string = policySetDefinition.id
output initiativeDefinitionName string = policySetDefinition.name
