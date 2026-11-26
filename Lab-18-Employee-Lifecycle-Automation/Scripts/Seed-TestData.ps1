Import-Module ActiveDirectory

$Domain   = Get-ADDomain
$DomainDN = $Domain.DistinguishedName

$Password = Read-Host "Enter a password for the test accounts" -AsSecureString

# Create the HR and Sales access groups if they do not exist
$NewGroups = @(
    @{ Name = "HR Staff";    Path = "OU=HR,$DomainDN" },
    @{ Name = "Sales Staff"; Path = "OU=Sales,$DomainDN" }
)

foreach ($Group in $NewGroups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($Group.Name)'")) {
        New-ADGroup -Name $Group.Name -GroupScope Global -GroupCategory Security -Path $Group.Path
    }
}

# Create two test employees if they do not exist
$TestUsers = @(
    @{ Name = "Chisom Mmesoma"; Given = "Chisom"; Surname = "Mmesoma"; Sam = "Chisom.Mmesoma";
       Department = "Sales"; Title = "Sales Representative"; Path = "OU=Sales,$DomainDN";
       Groups = @("Sales Staff") },
    @{ Name = "Test Employee"; Given = "Test"; Surname = "Employee"; Sam = "testemployee";
       Department = "IT"; Title = "Cloud Engineer"; Path = "OU=Cloud Engineer,OU=IT,$DomainDN";
       Groups = @("IT Staff", "CLOUD ENG") }
)

foreach ($User in $TestUsers) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.Sam)'")) {
        New-ADUser `
            -Name $User.Name `
            -GivenName $User.Given `
            -Surname $User.Surname `
            -SamAccountName $User.Sam `
            -UserPrincipalName "$($User.Sam)@$($Domain.DNSRoot)" `
            -Department $User.Department `
            -Title $User.Title `
            -Path $User.Path `
            -AccountPassword $Password `
            -Enabled $true
    }

    foreach ($Group in $User.Groups) {
        $Members = @(Get-ADGroupMember -Identity $Group).SamAccountName

        if ($Members -notcontains $User.Sam) {
            Add-ADGroupMember -Identity $Group -Members $User.Sam
        }
    }
}