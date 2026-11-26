# Offboard-Employees.ps1
. "$PSScriptRoot\Lifecycle-Common.ps1"
$ErrorActionPreference = 'Stop'

$InputFile = Join-Path $LifecycleRoot 'Input\Offboarding.csv'
$LogFile   = Join-Path $LifecycleRoot 'Logs\Offboarding.log'
$DisabledOU = "OU=Disabled Users,$DomainDN"
$EmployeeOUs = @("OU=HR,$DomainDN", "OU=IT,$DomainDN", "OU=Sales,$DomainDN")

if (-not (Test-Path -LiteralPath $InputFile)) { throw "The offboarding CSV file was not found: $InputFile" }
if (-not (Get-ADOrganizationalUnit -Identity $DisabledOU -ErrorAction SilentlyContinue)) {
    throw "The Disabled Users OU was not found: $DisabledOU. Create it before running offboarding."
}

$ManagedGroups = Get-ManagedGroups
$Requests = @(Import-Csv -LiteralPath $InputFile)
if ($Requests.Count -eq 0) { throw 'The offboarding CSV contains no requests.' }

foreach ($Departure in $Requests) {
    $CompletedActions = @()
    $Sam = ([string]$Departure.SamAccountName).Trim()
    try {
        if ([string]::IsNullOrWhiteSpace($Sam)) { throw 'The employee account name is missing.' }
        $Reason = ([string]$Departure.Reason).Trim()
        if ([string]::IsNullOrWhiteSpace($Reason)) { $Reason = 'Not recorded' }

        $User = Get-ADUser -Identity $Sam -Properties Department, Title, MemberOf, Enabled
        if (-not $User.Enabled) { throw 'The employee account is already disabled.' }

        $InEmployeeOU = $false
        foreach ($OU in $EmployeeOUs) {
            if ($User.DistinguishedName.EndsWith(",$OU", [System.StringComparison]::OrdinalIgnoreCase)) {
                $InEmployeeOU = $true
                break
            }
        }
        if (-not $InEmployeeOU) { throw 'The account is not located in an approved employee OU.' }

        $GroupsToRemove = @($User.MemberOf |
            ForEach-Object { (Get-ADGroup -Identity $_).Name } |
            Where-Object { $_ -in $ManagedGroups })

        Disable-ADAccount -Identity $Sam
        $CompletedActions += 'Disabled account'

        foreach ($Group in $GroupsToRemove) {
            Remove-ADGroupMember -Identity $Group -Members $Sam -Confirm:$false
            $CompletedActions += "Removed group: $Group"
        }

        Set-ADUser -Identity $Sam -Description "Offboarded $(Get-Date -Format 'yyyy-MM-dd'): $Reason"
        $CompletedActions += 'Recorded offboarding date and reason'

        # Refresh the DN after prior directory operations, then move the account.
        $CurrentUser = Get-ADUser -Identity $Sam
        Move-ADObject -Identity $CurrentUser.DistinguishedName -TargetPath $DisabledOU
        $CompletedActions += 'Moved account to Disabled Users OU'

        Write-Log "SUCCESS: Disabled '$Sam'. Department: $($User.Department). Job title: $($User.Title). Removed groups: $(Format-ItemList $GroupsToRemove). Reason: $Reason."
    }
    catch {
        if ($CompletedActions.Count -gt 0) {
            Write-Log "PARTIAL: '$Sam'. Completed: $(Format-ItemList $CompletedActions). Error: $($_.Exception.Message)"
        }
        else {
            Write-Log "FAILED: '$Sam' - $($_.Exception.Message)"
        }
    }
}
