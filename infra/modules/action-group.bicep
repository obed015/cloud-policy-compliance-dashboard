targetScope = 'resourceGroup'

@description('Name of the Action Group.')
param actionGroupName string

@description('Short name for the Action Group.')
@maxLength(12)
param shortName string

@description('Email address to receive alerts.')
param alertEmailAddress string

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'

  properties: {
    groupShortName: shortName
    enabled: true

    emailReceivers: [
      {
        name: 'PrimaryEmailReceiver'
        emailAddress: alertEmailAddress
        useCommonAlertSchema: true
      }
    ]
  }
}

output actionGroupId string = actionGroup.id
output actionGroupNameOut string = actionGroup.name
