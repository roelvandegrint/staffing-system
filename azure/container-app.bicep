param container_app_name string
param container_app_environment_name string
param container_image string
param container_name string
@secure()
param container_registry_username string
@secure()
param container_registry_password string
param container_registry_uri string
param container_env array = []
param ingress_external bool
param ingress_target_port int
param location string

resource container_app_environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: container_app_environment_name
}

resource containerapp 'Microsoft.App/containerApps@2022-03-01' = {
  name: container_app_name
  location: location
  tags: {}
  properties: {
    managedEnvironmentId: container_app_environment.id
    configuration: {
      activeRevisionsMode: 'single'
      ingress: {
        allowInsecure: false
        external: ingress_external
        targetPort: ingress_target_port
      }
      secrets: [
        {
          name: 'container-registry-password'          
          value: container_registry_password
        }
      ]
      registries: [
        {
          server: container_registry_uri
          username: container_registry_username
          passwordSecretRef: 'container-registry-password'
        }
      ]
    }
    template: {
      containers: [
        {          
          image: container_image
          name: container_name
          env: container_env
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
