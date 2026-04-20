targetScope = 'managementGroup'

@description('Management group ID where the governance baseline will be deployed.')
param mgId string

module policyPublicNetworkAccess './policy-public-network-access.bicep' = {
  name: 'policy-public-network-access'
  scope: managementGroup(mgId)
  params: {}
}

module initiativeCloudGovernance './initiative-cloud-governance.bicep' = {
  name: 'initiative-cloud-governance'
  scope: managementGroup(mgId)
  params: {
    publicNetworkPolicyDefinitionId: policyPublicNetworkAccess.outputs.policyDefinitionId
  }
}

module assignmentCloudGovernance './assignment-cloud-governance.bicep' = {
  name: 'assignment-cloud-governance'
  scope: managementGroup(mgId)
  params: {
    initiativeDefinitionId: initiativeCloudGovernance.outputs.initiativeDefinitionId
  }
}

output policyDefinitionId string = policyPublicNetworkAccess.outputs.policyDefinitionId
output initiativeDefinitionId string = initiativeCloudGovernance.outputs.initiativeDefinitionId
output assignmentId string = assignmentCloudGovernance.outputs.assignmentId
