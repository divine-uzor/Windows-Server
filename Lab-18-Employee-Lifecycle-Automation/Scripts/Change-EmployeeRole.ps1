# Change-EmployeeRole.ps1
. "$PSScriptRoot\Lifecycle-Common.ps1"
$ErrorActionPreference = 'Stop'

$InputFile = Join-Path $LifecycleRoot 'Input\RoleChanges.csv'
$LogFile   = Join-Path $LifecycleRoot 'Logs\RoleChanges.log'
if (-not (Test-Path -LiteralPath $InputFile)) { throw "The role-change CSV file was not found: $InputFile" }

$ManagedGroups = Get-ManagedGroups
$Requests = @(Import-Csv -LiteralPath $InputFile)
if ($Requests.Count -eq 0) { throw 'The role-change CSV contains no requests.' }

foreach ($Change in $Requests) {
    $CompletedActions = @()
    $Sam = ([string]$Change.SamAccountName).Trim()
    try {
        $NewDepartment = ([string]$Change.NewDepartment).Trim()
        $NewJobTitle   = ([string]$Change.NewJobTitle).Trim()
        $NewOU         = ([string]$Change.NewOU).Trim()

        if ([string]::IsNullOrWhiteSpace($Sam) -or [string]::IsNullOrWhiteSpace($NewDepartment) -or
            [string]::IsNullOrWhiteSpace($NewJobTitle) -or [string]::IsNullOrWhiteSpace($NewOU)) {
            throw 'A required employee field is empty.'
        }

        $Rule = Get-RoleRule -Department $NewDepartment -JobTitle $NewJobTitle
        if ($null -eq $Rule) { throw "No approved role matches '$NewDepartment / $NewJobTitle'." }
        if ($Rule.TargetOU -ne $NewOU) { throw "The requested OU '$NewOU' does not match the approved OU '$($Rule.TargetOU)'." }
        $NewOUPath = Resolve-TargetOU -Name $Rule.TargetOU

        $User = Get-ADUser -Identity $Sam -Properties Department, Title, MemberOf
        if (-not $User.Enabled) { throw 'The employee account is disabled.' }

        $OldDepartment = $User.Department
        $OldTitle      = $User.Title
        $CurrentOU     = ($User.DistinguishedName -split ',', 2)[1]
        $CurrentGroups = @($User.MemberOf | ForEach-Object { (Get-ADGroup -Identity $_).Name })
        $NewGroups     = Get-GroupList $Rule.Groups
        $GroupsToAdd   = @($NewGroups | Where-Object { $_ -notin $CurrentGroups })
        $GroupsToRemove = @($CurrentGroups | Where-Object { $_ -in $ManagedGroups -and $_ -notin $NewGroups })

        # Grant the new role's groups before removing obsolete managed groups.
        foreach ($Group in $GroupsToAdd) {
            Add-ADGroupMember -Identity $Group -Members $Sam
            $CompletedActions += "Added group: $Group"
        }

        Set-ADUser -Identity $Sam -Department $NewDepartment -Title $NewJobTitle
        $CompletedActions += 'Updated Department and Job Title'

        if ($CurrentOU -ine $NewOUPath) {
            Move-ADObject -Identity $User.DistinguishedName -TargetPath $NewOUPath
            $CompletedActions += "Moved account to $NewOUPath"
        }

        foreach ($Group in $GroupsToRemove) {
            Remove-ADGroupMember -Identity $Group -Members $Sam -Confirm:$false
            $CompletedActions += "Removed group: $Group"
        }

        Write-Log "SUCCESS: Updated '$Sam' from '$OldDepartment / $OldTitle' to '$NewDepartment / $NewJobTitle'. Added: $(Format-ItemList $GroupsToAdd). Removed: $(Format-ItemList $GroupsToRemove)."
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
