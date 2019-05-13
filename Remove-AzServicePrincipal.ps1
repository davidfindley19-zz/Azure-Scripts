Function Remove-AzServicePrincipal {

if($azureConnection.Account -eq $null){
    $azureConnection = Connect-AzureAD 
}
$ConnectionStatus = Get-AzureADTenantDetail
$DisplayName = $ConnectionStatus.DisplayName
Write-Host "Connected to: $DisplayName " -ForegroundColor Green "`n"
$AppNameEntry = Read-Host "Please enter an app name: "
$Application = Get-AzureADApplication -SearchString $AppNameEntry
$ObjectID = $Application.ObjectID

Write-Host "`nThe application's objectID is: $ObjectID" -ForegroundColor Blue

Write-Host "`nWould you like to remove the Service Principal $ObjectID?"
$RemoveResponse = Read-Host "[Y]es or [N]o"
switch ($RemoveResponse){
    Y {Write-Host "`nRemoving the Service Principal $ObjectID..." -ForegroundColor Blue; $RemoveResponse = $true}
    N {Write-Host "`nSkipping the removal of $ObjectID. Exiting the script." -ForegroundColor Blue; $RemoveResponse = $false}
    Default {"`nInvalid response. Exiting. "; exit}
}
if ($RemoveResponse -eq $true){
    Remove-MsolServicePrincipal -ObjectId $ObjectID
}
elseif ($RemoveResponse -eq $false){
    exit
}
}
