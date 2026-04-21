targetScope = 'managementGroup'

@description('Name of the initiative definition.')
param initiativeName string = 'cloud-governance-baseline'

@description('Display name shown in Azure Policy.')
param initiativeDisplayName string = 'Cloud Governance Baseline'

@description('Description for the initiative.')
param initiativeDescription string = 'Groups governance policies for platform-wide Azure compliance and remediation.'

@description('Resource ID of the audit policy definition.')
param publicNetworkAuditPolicyDefinitionId string

@description('Resource ID of the remediation policy definition.')
param publicNetworkRemediationPolicyDefinitionId string

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2025-03-01' = {
  name: initiativeName
  properties: {
    policyType: 'Custom'
    displayName: initiativeDisplayName
    description: initiativeDescription
    metadata: {
      category: 'Governance'
      version: '2.0.0'
    }
    parameters: {}
    policyDefinitions: [
      {
        policyDefinitionId: publicNetworkAuditPolicyDefinitionId
        policyDefinitionReferenceId: 'auditStoragePublicNetworkAccess'
      }
      {
        policyDefinitionId: publicNetworkRemediationPolicyDefinitionId
        policyDefinitionReferenceId: 'remediateStorageDefaultDeny'
      }
    ]
  }
}

output initiativeDefinitionId string = policySetDefinition.id
output initiativeDefinitionName string = policySetDefinition.name
