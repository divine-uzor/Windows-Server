# Onboard-Employees.ps1
. "$PSScriptRoot\Lifecycle-Common.ps1"
$ErrorActionPreference = 'Stop'

$InputFile = Join-Path $LifecycleRoot 'Input\Onboarding.csv'
$LogFile   = Join-Path $LifecycleRoot 'Logs\Onboarding.log'
if (-not (Test-Path -LiteralPath $InputFile)) { throw "The onboarding CSV file was not found: $InputFile" }

$RequiredFields = @('FirstName','LastName','SamAccountName','UserPrincipalName','Department','JobTitle','TargetOU')
$Requests = @(Import-Csv -LiteralPath $InputFile)
if ($Requests.Count -eq 0) { throw 'The onboarding CSV contains no requests.' }

foreach ($Employee in $Requests) {
    $CompletedActions = @()
    $Sam = [string]$Employee.SamAccountName
    try {
        foreach ($Field in $RequiredFields) {
            if ([string]::IsNullOrWhiteSpace([string]$Employee.$Field)) { throw "Required field '$Field' is empty." }
        }

        $Sam        = $Employee.SamAccountName.Trim()
        $UPN        = $Employee.UserPrincipalName.Trim()
        $Department = $Employee.Department.Trim()
        $JobTitle   = $Employee.JobTitle.Trim()
        $TargetOU   = $Employee.TargetOU.Trim()

        if ($Sam -notmatch '^[a-zA-Z0-9._-]{1,20}$') { throw 'The SamAccountName format is invalid.' }
        if ($UPN -notmatch '^[^@\s'']+@[^@\s'']+$') { throw 'The UserPrincipalName format is invalid.' }
        if ($UPN.Split('@')[1] -ine $DomainDNS) { throw 'The UPN suffix does not match the company domain.' }

        $Rule = Get-RoleRule -Department $Department -JobTitle $JobTitle
        if ($null -eq $Rule) { throw "No approved role matches '$Department / $JobTitle'." }
        if ($Rule.TargetOU -ne $TargetOU) { throw "The requested OU '$TargetOU' does not match the approved OU '$($Rule.TargetOU)'." }
        $OUPath = Resolve-TargetOU -Name $Rule.TargetOU

        if (Get-ADUser -Filter "SamAccountName -eq '$Sam'") { throw 'The account name already exists.' }
        if (Get-ADUser -Filter "UserPrincipalName -eq '$UPN'") { throw 'The User Principal Name already exists.' }

        $SecurePassword = Read-Host "Enter temporary password for $Sam" -AsSecureString
        New-ADUser -Name "$($Employee.FirstName.Trim()) $($Employee.LastName.Trim())" `
            -GivenName $Employee.FirstName.Trim() `
            -Surname $Employee.LastName.Trim() `
            -SamAccountName $Sam `
            -UserPrincipalName $UPN `
            -Department $Department `
            -Title $JobTitle `
            -Path $OUPath `
            -AccountPassword $SecurePassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true
        $CompletedActions += 'Created and enabled account'

        $Groups = Get-GroupList $Rule.Groups
        foreach ($Group in $Groups) {
            Add-ADGroupMember -Identity $Group -Members $Sam
            $CompletedActions += "Added group: $Group"
        }

        Write-Log "SUCCESS: Created '$Sam' in '$($Rule.TargetOU)' as '$JobTitle'. Groups: $(Format-ItemList $Groups)."
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
