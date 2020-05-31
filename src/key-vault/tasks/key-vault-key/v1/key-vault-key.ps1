. "${PSScriptRoot}\ps_modules\AzureBuilder\cmdlets\interface\Connect-AzureBuilderDevOpsAccount.ps1"
. "${PSScriptRoot}\helpers.ps1"

$keyVaultName = Get-VstsInput -Name keyVaultName -Require
$uploadType = Get-VstsInput -Name uploadType -Require
$settings = @{ }

Connect-AzureBuilderDevOpsAccount -Name "ConnectedServiceNameARM"

if(@('Import', 'Restore') -contains $uploadType)
{
    $keyFilePath = Get-VstsInput -Name keyFile -Require
}

if(@('Generate', 'Import') -contains $uploadType)
{
    $activationDate = Get-KeyVaultKeyDateSettings -Type "Activation"
    if($activationDate)
    {
        $settings.Add('NotBefore', $activationDate)
    }

    $expirationDate = Get-KeyVaultKeyDateSettings -Type "Expiration"
    if($expirationDate)
    {
        $settings.Add('Expires', $expirationDate)
    }

    switch($uploadType)
    {
        "Generate"
        {
            $keySize = [int](Get-VstsInput -Name KeySize -Require) 
            $settings.Add('Size', $keySize)
        }
        "Import"
        {
            $keyFilePath = (Get-VstsInput -Name keyFile -Require)
            $settings.Add('KeyFilePath', $keyFilePath)
        }
    }

    $keyName = Get-VstsInput -Name KeyName -Require
    $destination = Get-VstsInput -Name Destination -Require
    $key = Add-AzKeyVaultKey -VaultName $keyVaultName -Name $KeyName @settings -Destination $destination
}
else 
{
    try
    {
        $key = Restore-AzKeyVaultKey -VaultName $keyVaultName -InputFile $keyFilePath -ErrorAction Stop
    }
    catch
    {
        $errorOnConflict = Get-VstsInput -Name "errorOnConflict" -AsBool

        if(!($errorOnConflict) -and ($_.Exception -like "*Conflict*"))
        {
            Write-Warning "Could not restore $(Split-Path $keyFilePath -Leaf) into ${keyVaultName}, key already exists"
        }
        else 
        {
            Write-Error $_
        }
    }
}

Write-Host "##vso[task.setvariable variable=KEY_VERSION;isOutput=true;]$($key.Version)"