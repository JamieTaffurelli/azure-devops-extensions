[![Donate](images/donate.png)](https://paypal.me/jtaffurelli)

# Azure What if ARM Template Deploy Task
Azure DevOps task that allows what if test deployments for understanding how an ARM template deployment would change your enviromnent

## UI

![Deploy parameters](images/task-screenshot.png)

## YAML
```yaml
- task: JamieTaffurelli.azure-what-if.azure-what-if.azure-what-if@0
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
**0.0.1**
- Currently still in development
