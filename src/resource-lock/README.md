# Resource Lock Task
Azure DevOps task that allows deployment at Tenant level with ARM template (invokes New-AzTenantDeployment)

## UI

![Tenant Deploy parameters](images/task-screenshot.png)

## YAML
```yaml
- task: JamieTaffurelli.azure-resource-lock.azure-resource-lock.azure-resource-lock@0
  displayName: Specify task display name
  inputs:
    azureSubscription: Service Connection to authenticate with
    Action: 'Lock' or 'Unlock', lock or unlock a resource or resource group
    LockLevel: 'Readonly' or 'CanNotDelete', for Action 'Lock'
    LockName: Name of lock
    ResourceGroupName: Resource group for lock
    ResourceType: Resource Type for lock, not mandatory
    ResourceName: Resource name for lock, not mandatory
    Skip: boolean, skip if a lock already exists wiht the same name


# Release Notes
**1.0.0**
- Initial task release with basic functionality
