param location string = resourceGroup().location
var container_app_name = 'cont-staffing-employees-svc'

// TODO: Provide container apps environment name from pipeline variables
resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: 'contenv-staffing-system'
}

resource containerapp 'Microsoft.App/containerApps@2022-03-01' = {
  name: container_app_name
  location: location
  tags: {}
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      activeRevisionsMode: 'single'
      ingress: {
        allowInsecure: false
        external: false
        targetPort: 80
      }
      secrets: [
        {
          name: 'container-registry-password'
          // TODO: Provide this secret from pipeline secrets
          value: 'JP+1FoPfSgPBJemgQD84Pfh3f7+1tPhI'
        }
      ]
      registries: [
        {
          server: 'roelvandegrint.azurecr.io'
          username: 'roelvandegrint'
          passwordSecretRef: 'container-registry-password'
        }
      ]
    }
    template: {
      containers: [
        {
          // TODO: Provide image from pipeline variables
          image: 'roelvandegrint.azurecr.io/cont-staffing-employees-svc:a5209b874ccf3996ef9c5e00af33c068cd0084d9'
          name: 'frontend'
          env: []
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}
