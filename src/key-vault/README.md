# Key Vault Extension
Set of tasks for deploying certificates (string and file input) and keys (import, generate, restore) to Key Vault

# Key Vault Certificate Deploy Task
Azure DevOps task that allows deployment of a certificate to Key Vault, takes string and file path input

## UI

![Key Vault Cert parameters](images/task-screenshot-cert.png)

## YAML
```yaml
- task: JamieTaffurelli.azure-key-vault-key-cert-deploy.key-vault-certificate-generation.key-vault-certificate-generation@1
  displayName: Specify task display name
  inputs:
    azureSubscription: Service Connection to authenticate with
    keyVaultName: Specify Key Vault to upload certificate to
    certificateName: Specify name of certificate in Key Vault
    uploadType: 'filePath' or 'string', specify a base-64 encoded string or a path to a certificate file
    certFile: Specify artifact or repo type, for uploadType 'filePath'
    certString: Specify base-64 encoded string, for uploadType 'string'
    password: Specify password for the certifcate, not mandatory
```
# Key Vault Certificate Deploy Task
Azure DevOps task that allows deployment of a key to Key Vault. Generate, import and restore functions are supported

## UI

![Key Vault Key parameters](images/task-screenshot-key.png)

## YAML
```yaml
- task: JamieTaffurelli.azure-key-vault-key-cert-deploy.key-vault-key-generation.key-vault-key-generation@0
  displayName: Specify task display name
  inputs:
    azureSubscription: Service Connection to authenticate with
    keyVaultName: Specify Key Vault
    uploadType: 'Generate', 'Import' or 'Restore'.
    keyName: Specify name of key, for uploadType 'Generate' or 'Import'
    KeySize: '2048', '3072', '4096' bit size of RSA key, for uploadType 'Generate'
    Destination: 'Software' or 'HSM', for uploadType 'Generate' or 'Import'
    SetActivation: boolean, for uploadType 'Generate' or 'Import'
    ActivationDateType: 'Relative' or 'Specific'
    ActivationDateHours: Number of hours from execution to activate key, for uploadType 'Generate' or 'Import' and ActivationDateType 'Relative'
    ActivationDateDays: Number of days from execution to activate key, for uploadType 'Generate' or 'Import' and ActivationDateType 'Relative'
    ActivationDateMonths: Number of months from execution to activate key, for uploadType 'Generate' or 'Import' and ActivationDateType 'Relative'
    ActivationDateSpecific: Date to activate key in ISO 8601 format, for uploadType 'Generate' or 'Import' and ActivationDateType 'Specific'
    SetExpiration: boolean, for uploadType 'Generate' or 'Import'
    ExpirationDateType: 'Relative' or 'Specific'
    ExpirationDateHours: Number of hours from execution to expire key, for uploadType 'Generate' or 'Import' and ExpirationDateType 'Relative'
    ExpirationDateDays: Number of days from execution to expire key, for uploadType 'Generate' or 'Import' and ExpirationDateType 'Relative'
    ExpirationDateMonths: Number of months from execution to expire key, for uploadType 'Generate' or 'Import' and ExpirationDateType 'Relative'
    ExpirationDateSpecific: Date to expire key in ISO 8601 format, for uploadType 'Generate' or 'Import' and ExpirationDateType 'Specific'
    keyFile: Path the key file for restoration, for uploadType 'Restore'
    errorOnConflict: boolean, error if there is a conflict, for uploadType 'Restore'
```

# Release Notes
**1.0.0**
- Initial extension release with basic functionality
