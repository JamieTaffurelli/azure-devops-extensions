. "${PSScriptRoot}\ps_modules\AzureBuilder\cmdlets\interface\Connect-AzureBuilderDevOpsAccount.ps1"

$ResourceGroupName = Get-VstsInput -Name ResourceGroupName -Require
$ResourceType = Get-VstsInput -Name ResourceName -Default ([String]::Empty)
$ResourceName = Get-VstsInput -Name ResourceName -Default ([String]::Empty)
$Action = Get-VstsInput -Name Action -Require
$LockLevel = Get-VstsInput -Name LockLevel -Default ([String]::Empty)
$LockName = Get-VstsInput -Name LockName -Default ([String]::Empty)
$Skip = Get-VstsInput -Name Skip -AsBool

Connect-AzureBuilderDevOpsAccount -Name "ConnectedServiceNameARM"

$params = @{ }

if($ResourceName -or ($ResourceName -ne ([String]::Empty)))
{
    $params.Add('ResourceName', $ResourceName)
    $params.Add('ResourceType', $ResourceType)
}

switch ($Action)
{
    "Lock"
    { 
        try 
        {
            $lock = Get-AzResourceLock @params -LockName $LockName -ResourceGroupName $ResourceGroupName -ErrorAction Stop

            if(!($lock -and $Skip))
            {
                throw "Lock: ${LockName} already exists at scope specified in ${ResourceGroupName}"
            }
        }
        catch
        {
            if($_.Exception -like "*LockNotFound*")
            {
                New-AzResourceLock -ResourceGroupName $ResourceGroupName @params -LockName $LockName -LockNotes "Az DevOps Pipeline ${LockName}" -LockLevel $LockLevel -Force
            }
            else 
            {
                throw $_
            }
        }
    }
    "Unlock"
    {
        if($LockName -or ($LockName -ne ([String]::Empty)))
        {
            Get-AzResourceLock -ResourceGroupName $ResourceGroupName @params -LockName $LockName -ErrorAction "SilentlyContinue" | Remove-AzResourceLock -Force
        }
        else 
        {
            Get-AzResourceLock -ResourceGroupName $ResourceGroupName @params | Remove-AzResourceLock -Force
        }
    }
}

