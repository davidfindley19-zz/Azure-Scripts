function Add-AzADGroup{
<#
.SYNOPSIS
    Pulls information from CSV to bulk create Azure AD Groups.
.DESCRIPTION
    Pulls information for CSV to create bulk Azure AD Groups. The scripts assumes you have the ObjectID of the owner in the csv.
    We default to two owners for all AD groups.
.NOTES
    Author: David Findley
    Date: October 10, 2019
    Version: 1.1
    Change Log:
                1.0 (10/1) - Initial version of the script. 
                1.1 (1/10) - Updated to check for Azure AD connection and added line for secondary owner.
#>

# Checks the connection to the Azure AD tenant.
if($azureConnection.Account -eq $null){
    $azureConnection = Connect-AzureAD 
}
$ConnectionStatus = Get-AzureADTenantDetail
$DisplayName = $ConnectionStatus.DisplayName
Write-Host `n"Connected to: $DisplayName " -ForegroundColor Green "`n"

$Groups = Import-CSV C:\Temp\newazgroups.csv

# Sets each field of the csv to a variable. The script would break if I used the $Group.displayname format. 
foreach ($Group in $Groups){
    $GroupName = $Group.displayname 
    $GroupDescription = $Group.description 
    $GroupOwner1 = $Group.owner
    $GroupOwner2 = $Group.owner2

# Creating the groups and assigning owners.
    Write-Host "Creat new Azure AD Group: $GroupName"
    New-AzureADGroup -DisplayName $GroupName -Description $GroupDescription -MailEnabled $false -SecurityEnabled $true -MailNickName $GroupName
    $AzApp = Get-AzureADGroup -SearchString $GroupName
    $ObjectID = $AzApp.objectid
    Write-Host "Setting new owner for $GroupName."
    Add-AzureADGroupOwner -ObjectId $ObjectID -RefObjectId $GroupOwner1
    Add-AzureADGroupOwner -ObjectId $ObjectID -RefObjectId $GroupOwner2
}
}
# Exports the function as a PowerShell module. 
Export-ModuleMember -Function Add-AZADGroup
