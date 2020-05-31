
$scriptPath = "${PSScriptRoot}\key-vault-key.ps1"

function Get-VstsInput ($Name, [switch]$Require, [switch]$AsBool) { return $Name }
function Connect-AzureBuilderDevOpsAccount ($serviceNameInput, [switch]$Az) { }

Describe "key-vault-key tests" {

    Mock -CommandName Add-AzKeyVaultKey
    Mock -CommandName Connect-AzureBuilderDevOpsAccount
    Mock -CommandName Import-Module
    Mock -CommandName Get-VstsInput -MockWith { 2048 } -ParameterFilter { $Name -eq "KeySize" }
    Mock -CommandName Get-VstsInput -MockWith { "Software" } -ParameterFilter { $Name -eq "Destination" }
    Mock -CommandName Get-VstsInput -MockWith { $TestDrive } -ParameterFilter { $Name -eq "keyFile" }

    Context "Key Expiry and Activation Functionality" {

        It "Adds key with no expiry or activation date" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 2 -Scope It -Exactly -ParameterFilter { ($NotBefore -eq $null) -and ($Expires -eq $null) }
        }

        It "Adds key with specific expiry" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $true } -ParameterFilter { $Name -eq "SetExpiration" }
            Mock -CommandName Get-VstsInput -MockWith { "2020-02-18T09:38:26.7680944+00:00" } -ParameterFilter { $Name -eq "ExpirationDateSpecific" }

            { . $scriptPath } | should not throw

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 2 -Scope It -Exactly -ParameterFilter { ($NotBefore -eq $null) -and ($Expires -eq "2020-02-18T09:38:26.7680944+00:00") }
        }

        It "Adds key with relative expiry" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $true } -ParameterFilter { $Name -eq "SetExpiration" }
            Mock -CommandName Get-VstsInput -MockWith { "Relative" } -ParameterFilter { $Name -eq "ExpirationDateType" }
            Mock -CommandName Get-VstsInput -MockWith { "0" } -ParameterFilter { $Name -eq "ExpirationDateHours" }
            Mock -CommandName Get-VstsInput -MockWith { "1" } -ParameterFilter { $Name -eq "ExpirationDateDays" }
            Mock -CommandName Get-VstsInput -MockWith { "0" } -ParameterFilter { $Name -eq "ExpirationDateMonths" }
            Mock -CommandName Get-VstsInput -MockWith { "0" } -ParameterFilter { $Name -eq "ExpirationDateYears" }

            { . $scriptPath } | should not throw

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 2 -Scope It -Exactly -ParameterFilter { ($NotBefore -eq $null) -and ($Expires.Day -eq (Get-Date).AddDays(1).Day) }
        }

        It "Adds key with specific activation" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $true } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }
            Mock -CommandName Get-VstsInput -MockWith { "2020-02-18T09:38:26.7680944+00:00" } -ParameterFilter { $Name -eq "ActivationDateSpecific" }

            { . $scriptPath } | should not throw

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 2 -Scope It -Exactly -ParameterFilter { ($Expires -eq $null) -and ($NotBefore -eq "2020-02-18T09:38:26.7680944+00:00") }
        }

        It "Adds key with relative activation" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $true } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }
            Mock -CommandName Get-VstsInput -MockWith { "Relative" } -ParameterFilter { $Name -eq "ActivationDateType" }
            Mock -CommandName Get-VstsInput -MockWith { "0" } -ParameterFilter { $Name -eq "ActivationDateHours" }
            Mock -CommandName Get-VstsInput -MockWith { "1" } -ParameterFilter { $Name -eq "ActivationDateDays" }
            Mock -CommandName Get-VstsInput -MockWith { "0" } -ParameterFilter { $Name -eq "ActivationDateMonths" }
            Mock -CommandName Get-VstsInput -MockWith { "0" } -ParameterFilter { $Name -eq "ActivationDateYears" }

            { . $scriptPath } | should not throw

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 2 -Scope It -Exactly -ParameterFilter { ($Expires -eq $null) -and ($NotBefore.Day -eq (Get-Date).AddDays(1).Day) }
        }
    }

    Context "Key Size Settings" {

        It "Sets key size on generate" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 1 -Scope It -Exactly -ParameterFilter { $Size -eq 2048 }
        }

        It "Skips set key size on import" {

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 1 -Scope It -Exactly -ParameterFilter { $Size -eq $null }
        }
    }

    Context "Import File Settings" {

        It "Sets key file path on import" {

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 1 -Scope It -Exactly -ParameterFilter { $KeyFilePath -eq $TestDrive }
        }

        It "Skips set key size on Generate" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 1 -Scope It -Exactly -ParameterFilter { $KeyFilePath -eq $null }
        }
    }

    Context "Key Destination Settings" {

        It "Sets destination on generate" {

            Mock -CommandName Get-VstsInput -MockWith { "Generate" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 1 -Scope It -Exactly -ParameterFilter { $Destination -eq "Software" }
        }

        It "Sets destination on import" {

            Mock -CommandName Get-VstsInput -MockWith { "Import" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetActivation" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "SetExpiration" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Add-AzKeyVaultKey -Times 1 -Scope It -Exactly -ParameterFilter { $Destination -eq "Software" }
        }
    }

    Context "Restore key backup" {

        It "Restores from backup" {

            Mock -CommandName Restore-AzKeyVaultKey
            Mock -CommandName Get-VstsInput -MockWith { "Restore" } -ParameterFilter { $Name -eq "uploadType" }

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Restore-AzKeyVaultKey -Times 1 -Scope It -Exactly
        }

        It "Warns on conflict if errorOnConflict is false" {

            Mock -CommandName Restore-AzKeyVaultKey -MockWith { throw "Conflict" }
            Mock -CommandName Get-VstsInput -MockWith { "Restore" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "errorOnConflict" }
            Mock -CommandName Write-Warning

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Restore-AzKeyVaultKey -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Warning -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Could not restore $(Split-Path $TestDrive -Leaf) into keyVaultName, key already exists" }
        }

        It "Errors errorOnConflict is false and there is a non-conflict error" {

            Mock -CommandName Restore-AzKeyVaultKey -MockWith { throw "403" }
            Mock -CommandName Get-VstsInput -MockWith { "Restore" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $false } -ParameterFilter { $Name -eq "errorOnConflict" }
            Mock -CommandName Write-Warning
            Mock -CommandName Write-Error

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Restore-AzKeyVaultKey -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Warning -Times 0 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "403" }
        }

        It "Errors on conflict if errorOnConflict is true" {

            Mock -CommandName Restore-AzKeyVaultKey -MockWith { throw "Conflict" }
            Mock -CommandName Get-VstsInput -MockWith { "Restore" } -ParameterFilter { $Name -eq "uploadType" }
            Mock -CommandName Get-VstsInput -MockWith { $true } -ParameterFilter { $Name -eq "errorOnConflict" }
            Mock -CommandName Write-Warning
            Mock -CommandName Write-Error

            { . $scriptPath } | should not throw

            Assert-MockCalled -CommandName Write-Warning -Times 0 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Conflict" }
        }
    }
}