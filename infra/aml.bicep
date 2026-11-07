param location string = resourceGroup().location
param suffix string

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'log-fitops-${suffix}'
  location: location
  properties: { sku: { name: 'PerGB2018' }, retentionInDays: 30 }
}

resource appi 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-fitops-${suffix}'
  location: location
  kind: 'web'
  properties: { Application_Type: 'web', WorkspaceResourceId: law.id }
}

resource st 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'stfitops${suffix}'
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: { minimumTlsVersion: 'TLS1_2', allowBlobPublicAccess: false }
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-fitops-${suffix}'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { family: 'A', name: 'standard' }
    accessPolicies: []
    softDeleteRetentionInDays: 7
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'crfitops${suffix}'
  location: location
  sku: { name: 'Basic' }
  properties: { adminUserEnabled: false }
}

resource ws 'Microsoft.MachineLearningServices/workspaces@2024-10-01' = {
  name: 'mlw-fitops-${suffix}'
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    friendlyName: 'FitOps'
    storageAccount: st.id
    keyVault: kv.id
    applicationInsights: appi.id
    containerRegistry: acr.id
    publicNetworkAccess: 'Enabled'
  }
}

output workspaceName string = ws.name
output appInsightsConnection string = appi.properties.ConnectionString
