. "${PSScriptRoot}\ps_modules\AzureBuilder\cmdlets\interface\Connect-AzureBuilderDevOpsAccount.ps1"

$keyVaultName = Get-VstsInput -Name keyVaultName -Require
$uploadType = Get-VstsInput -Name uploadType -Require
$certificateName = Get-VstsInput -Name certificateName -Require
$password = Get-VstsInput -Name password -Default ([String]::Empty)

if($password -eq ([String]::Empty))
{
    $passwordParam = @{ }
}
else 
{
    $passwordParam = @{ 
        Password = (ConvertTo-SecureString -String $password -AsPlainText -Force)
    }
}

Connect-AzureBuilderDevOpsAccount -Name "ConnectedServiceNameARM"

switch($uploadType) 
{
    "string"
    {
        $certString = Get-VstsInput -Name certString -Require
        Import-AzKeyVaultCertificate -VaultName $keyVaultName -CertificateString $certString @passwordParam -Name $certificateName
    }
    "filePath"
    {
        $filePath = Get-VstsInput -Name certFile -Require
        Import-AzKeyVaultCertificate -VaultName $keyVaultName -FilePath $filePath @passwordParam -Name $certificateName
    }   
}