[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [hashtable[]]
    $Modules,

    [Parameter()]
    [ValidateSet('Install', 'Save')]
    [string[]]
    $Mode = "Install"
)

Install-PackageProvider -Name NuGet -Force -Scope CurrentUser

switch($Mode)
{
    "Install"
    {
        foreach($module in $Modules)
        {
            Install-Module @module -Force -Scope CurrentUser -AllowClobber
        }
    }
    "Save"
    {
        foreach($module in $Modules)
        {
            Save-Module @module -Path .\ 
        }
    }
}

