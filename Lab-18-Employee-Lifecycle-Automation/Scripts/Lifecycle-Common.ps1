# Lifecycle-Common.ps1
# Shared settings and helper functions used by all employee lifecycle scripts.

Import-Module ActiveDirectory

$LifecycleRoot = "C:\Employee-Lifecycle"
$MatrixFile    = "$LifecycleRoot\Config\RoleMatrix.csv"

$Domain    = Get-ADDomain
$DomainDN  = $Domain.DistinguishedName
$DomainDNS = $Domain.DNSRoot

# Groups the automation may add or remove, in addition to the groups in the role matrix
$ExtraManagedGroups = @("CLOUD SNR")

function Write-Log {
    param([string]$Message)

    $Entry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"

    Add-Content -Path $LogFile -Value $Entry
    Write-Host $Entry
}

function Get-RoleMatrix {
    if (-not (Test-Path $MatrixFile)) {
        throw "The role matrix file was not found."
    }

    Import-Csv $MatrixFile
}

function Get-RoleRule {
    param([string]$Department, [string]$JobTitle)

    $RoleMatrix |
        Where-Object { $_.Department -eq $Department -and $_.JobTitle -eq $JobTitle } |
        Select-Object -First 1
}

function Get-GroupList {
    param([string]$Groups)

    @($Groups -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function Format-ItemList {
    param($Items)

    if (@($Items).Count -gt 0) { @($Items) -join '; ' } else { 'none' }
}

function Get-ManagedGroups {
    $FromMatrix = foreach ($Rule in $RoleMatrix) { Get-GroupList $Rule.Groups }

    @($FromMatrix + $ExtraManagedGroups) | Sort-Object -Unique
}

function Resolve-TargetOU {
    param([string]$Name)

    $Found = @(Get-ADOrganizationalUnit -Filter "Name -eq '$Name'")

    if ($Found.Count -eq 0) { throw "The OU '$Name' does not exist." }
    if ($Found.Count -gt 1) { throw "More than one OU is named '$Name'." }

    $Found[0].DistinguishedName
}

$RoleMatrix = Get-RoleMatrix