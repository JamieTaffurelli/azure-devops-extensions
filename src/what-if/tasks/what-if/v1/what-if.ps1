. "${PSScriptRoot}\ps_modules\AzureBuilder\cmdlets\interface\Connect-AzureBuilderDevOpsAccount.ps1"

Connect-AzureBuilderDevOpsAccount -Name "ConnectedServiceName"

$location = (Get-VstsInput -Name location -Require) -replace "\s", ""
$deploymentName = Get-VstsInput -Name deploymentName -Default (New-Guid)
$extraParameters = Get-VstsInput -Name extraParameters -Default ([string]::Empty)
$resultFormat = Get-VstsInput -Name resultFormat -Require
$excludeChangeType = ((Get-VstsInput -Name excludeChangeType -Default ([string]::Empty)) -replace " ", ([string]::Empty))

if($excludeChangeType -eq ([string]::Empty))
{
    $excludeChangeTypeParam = [string]::Empty
}
else 
{
    $excludeChangeTypeParam = "-ExcludeChangeType ${excludeChangeType}"
}

switch(Get-VstsInput -Name templateLocation -Require)
{
    "URL of the file"
    {
        $TemplateUri = Get-VstsInput -Name csmFileLink -Require 
        $TemplateParameterUri = Get-VstsInput -Name csmParametersFileLink -Require

        $params = "-Name ${deploymentName} -Location ${location} -TemplateUri ${TemplateUri} -TemplateParameterUri ${TemplateParameterUri} -SkipTemplateParameterPrompt -ResultFormat ${resultFormat} ${excludeChangeTypeParam} ${extraParameters}"
    }
    "Linked artifact"
    {
        $TemplateFile = Get-VstsInput -Name csmFile -Require 
        $TemplateParameterFile = Get-VstsInput -Name csmParametersFile -Require

        $params = "-Name ${deploymentName} -Location ${location} -TemplateFile ${TemplateFile} -TemplateParameterFile ${TemplateParameterFile} -SkipTemplateParameterPrompt -ResultFormat ${resultFormat} ${excludeChangeTypeParam} ${extraParameters}"
    }
}



switch(Get-VstsInput -Name deploymentScope -Require)
{

    "Management Group"
    {
        $managementGroupId = Get-VstsInput -Name managementGroupId -Require
        Invoke-Expression -Command ("Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId {0} {1}" -f $managementGroupId, $params)
    }
    "Subscription"
    {
        Invoke-Expression -Command ("Get-AzDeploymentWhatIfResult {0}" -f $params)
    }
    "Resource Group"
    {
        $resourceGroupName = Get-VstsInput -Name resourceGroupName -Require
        Invoke-Expression -Command ("Get-AzResourceGroupDeploymentWhatIfResult -ResourceGroupName {0} {1}" -f $resourceGroupName, $params)
    }
}

