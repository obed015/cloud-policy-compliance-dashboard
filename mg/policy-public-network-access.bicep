targetScope = 'managementGroup'

@description('Name of the custom policy definition.')
param policyName string = 'audit-storage-public-network-access'

@description('Display name shown in Azure Policy.')
param policyDisplayName string = 'Audit Storage Accounts with public network access enabled'

@description('Description for the custom policy.')
param policyDescription string = 'Audits Azure Storage Accounts where public network access is enabled.'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2025-03-01' = {
  name: policyName
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: policyDisplayName
    description: policyDescription
    metadata: {
      category: 'Storage'
      version: '1.0.0'
    }
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            field: 'Microsoft.Storage/storageAccounts/publicNetworkAccess'
            equals: 'Enabled'
          }
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

output policyDefinitionId string = policyDefinition.id
output policyDefinitionName string = policyDefinition.name
