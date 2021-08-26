### Install MMA Remotely Script###
### By Jack Lilley ## 08/23/2021 ###
### v.3 ###

### DOWNLOAD .64 MSI ###
$source = 'https://go.microsoft.com/fwlink/?LinkId=828603'
$destination = 'C:\windows\Temp\MMASetup-AMD64.exe'
Invoke-WebRequest -Uri $source -OutFile $destination

### INSTALL AND CONFIGURE MMA ###
Set-Location "C:\windows\temp\"
Start-Process -FilePath {C:\windows\Temp\MMASetup-AMD64.exe} -ArgumentList "/c /t:C:\windows\temp\setup"
Start-Sleep -Seconds 10
Start-Process -FilePath {C:\windows\Temp\setup\setup.exe} -ArgumentList "/qn NOAPM=1 ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_AZURE_CLOUD_TYPE=1 OPINSIGHTS_WORKSPACE_ID='8cb82737-8851-4337-8cb8-7d6b0a93c180' OPINSIGHTS_WORKSPACE_KEY='uvBDm7TpQJCHQ/NprZSpVcUYFQm6aipTt4URBnhddBc37E4Nu5jmUAROalBIXOe97uqWRA1RMo9Cr5k+yFdskw==' AcceptEndUserLicenseAgreement=1"
Write-Output "Install Complete"