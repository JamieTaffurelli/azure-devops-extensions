[![Donate](images/donate.png)](https://paypal.me/jtaffurelli)

# Tenant ARM Template Deploy Task
Azure DevOps task that allows deployment at Tenant level with ARM template (invokes New-AzTenantDeployment)

## UI

![Tenant Deploy parameters](images/task-screenshot.png)

## YAML
```yaml
- task: JamieTaffurelli.azure-tenant-deploy.azure-tenant-deploy.azure-tenant-deploy@1
  displayName: Specify task display name
  inputs:
     ConnectedServiceNameARM: Service Connection to authenticate with
     location: Location for deployment to take place
     templateLocation: 'Linked Artifact' or 'URL of the file', specify to get from artifact or URL
     csmFile: Path to artifact or repository template file, for linked artifact
     csmParametersFile: Path to artifact or repository parameters file, for linked artifact
     csmFileLink: URL to template file, for URL of the file
     csmParametersFileLink: URL to parameters file, for URL of the file
     extraParameters: Specify extra parameters not in parameters file, not these are not used as overrides, use powershell syntax
     deploymentName: Specify the name of the deployment as it appears in Azure
```

# Release Notes
**1.0.0**
- Initial task release with basic functionality
