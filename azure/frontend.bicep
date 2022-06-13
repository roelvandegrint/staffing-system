param container_app_name string
param container_app_environment_name string
param container_image string
param container_name string
@secure()
param container_registry_username string
@secure()
param container_registry_password string
param container_registry_uri string
param employees_svc_container_app_name string
param ingress_external bool
param ingress_target_port int
param location string = resourceGroup().location

resource container_app_environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: container_app_environment_name
}

resource employees_service 'Microsoft.App/containerApps@2022-03-01' existing = {
  name: employees_svc_container_app_name
}

module container_app './container-app.bicep' = {
  name: 'frontend_container_app'
  params: {
    container_app_environment_name: container_app_environment_name
    container_app_name: container_app_name
    container_image: container_image
    container_name: container_name
    container_registry_password: container_registry_password
    container_registry_uri: container_registry_uri
    container_registry_username: container_registry_username
    ingress_external: ingress_external
    ingress_target_port: ingress_target_port
    location: location
    container_env: [
      {
        name: 'EmployeesServiceBaseUri'
        value: employees_service.properties.configuration.ingress.fqdn
      }
    ]
  }
}
