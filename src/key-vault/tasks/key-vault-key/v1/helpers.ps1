function Get-KeyVaultKeyDateSettings
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateSet('Activation', 'Expiration')]
        $type
    )
    
    if(Get-VstsInput -Name ("Set{0}" -f $type) -Require -AsBool)
    {
        if((Get-VstsInput -Name ("{0}DateType" -f $type) -Require) -eq "Relative")
        {
            $hours = [int](Get-VstsInput -Name ("{0}DateHours" -f $type) -Require)
            $days = [int](Get-VstsInput -Name ("{0}DateDays" -f $type) -Require)
            $months = [int](Get-VstsInput -Name ("{0}DateMonths" -f $type) -Require)
            $years = [int](Get-VstsInput -Name ("{0}DateYears" -f $type) -Require)
            $date = (Get-Date).AddHours($hours).AddDays($days).AddMonths($months).AddYears($years)
        }
        else 
        {
            $date = [datetime](Get-VstsInput -Name ("{0}DateSpecific" -f $type) -Require)
        }

        return $date
    }
    else 
    {
        return $null   
    }
}