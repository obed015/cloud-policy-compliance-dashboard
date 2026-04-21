targetScope = 'managementGroup'

@description('Name of the remediation policy definition.')
param policyName string = 'modify-storage-disable-blob-public-access'

@description('Display name shown in Azure Policy.')
param policyDisplayName string = 'Remediate Storage Accounts to disable blob public access'

@description('Description for the remediation policy.')
param policyDescription string = 'Modifies Storage Accounts so allowBlobPublicAccess is set to false when found non-compliant.'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2025-03-01' = {
  name: policyName
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: policyDisplayName
    description: policyDescription
    metadata: {
      category: 'Storage'
      version: '2.0.0'
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
            field: 'Microsoft.Storage/storageAccounts/allowBlobPublicAccess'
            notEquals: false
          }
        ]
      }
      then: {
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab'
          ]
          conflictEffect: 'audit'
          operations: [
            {
              operation: 'addOrReplace'
              field: 'Microsoft.Storage/storageAccounts/allowBlobPublicAccess'
              value: false
            }
          ]
        }
      }
    }
  }
}

output policyDefinitionId string = policyDefinition.id
output policyDefinitionName string = policyDefinition.name
