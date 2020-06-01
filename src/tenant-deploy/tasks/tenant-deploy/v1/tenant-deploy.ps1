. "${PSScriptRoot}\ps_modules\AzureBuilder\cmdlets\interface\Connect-AzureBuilderDevOpsAccount.ps1"

Connect-AzureBuilderDevOpsAccount -Name "ConnectedServiceNameARM"

$location = Get-VstsInput -Name location -Require
$deploymentName = Get-VstsInput -Name deploymentName -Default (New-Guid)
$extraParameters = Get-VstsInput -Name extraParameters -Default ([string]::Empty)

switch(Get-VstsInput -Name templateLocation -Require)
{
    "URL of the file"
    {
        $TemplateUri = Get-VstsInput -Name csmFileLink -Require 
        $TemplateParameterUri = Get-VstsInput -Name csmParametersFileLink -Require

        Invoke-Expression -Command "New-AzTenantDeployment -Name ${deploymentName} -Location ${location} -TemplateUri ${TemplateUri} -TemplateParameterUri ${TemplateParameterUri} ${extraParameters}"
    }
    "Linked artifact"
    {
        $TemplateFile = Get-VstsInput -Name csmFile -Require 
        $TemplateParameterFile = Get-VstsInput -Name csmParametersFile -Require

        Invoke-Expression -Command "New-AzTenantDeployment -Name ${deploymentName} -Location ${location} -TemplateFile ${TemplateFile} -TemplateParameterFile ${TemplateParameterFile} ${extraParameters}"
    }
}

