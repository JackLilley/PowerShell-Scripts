### CREATE AN EXTERNAL USER ###
### v.1
### By: Jack Lilley 08/27/2021 ###
Write-Warning 'SCRIPT MUST BE RAN AS ADMINISTRATOR TO INSTALL THE PROPER MODULES.'

### COLLECT USER INFO ###
$MyDomain = Read-Host 'What is your email domain? Please use the "your-domain".onmicrosoft.us domain. EXAMPLE: contoso.onmicrosoft.us'
$FirstName = Read-Host 'What is the users first name?'
$LastName = Read-Host 'What is the users last name?'
$ExternalEmail = Read-Host 'What is the users external email?'
$FirstPW = Read-Host 'What would you like their first password to be?'

### CONFIRM USER INFO TO CONTINUE ###
Write-Output "Is this user info correct? `nFirstName: $FirstName `nLastName: $LastName `nExternal Email: $ExternalEmail `nFirst Password: $FirstPW"
$confirmation2 = Read-Host 'Are you Sure You Want To Proceed? "Y" to Continue "CTRL + C" to Stop.'
if ($confirmation2 -eq 'Y') {
    # proceed
}

### UNCOMMENT IF MODULES ARE NOT INSTALLED | INSTALL CLEAN PREREQUISITE MODULES ###
#Install-Module AzureAD -Force 
#Install-Module -Name ExchangeOnlineManagement -Force

### LOGIN AND GET USERNAME WITH MFA ###
Write-Output 'Lets get logged in. Next we will prompt for your credentials.'
Start-Sleep -Seconds 5
$UserName = Read-Host 'What is your username? EXAMPLE: user@contoso.us'
Connect-AzureAD -AzureEnvironment AzureUSGovernment -AccountId $UserName

### CREATE USERS AND CONVERT USERS TO GUESTS ###
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "$FirstPW"
New-AzureADUser -DisplayName "$FirstName $LastName (External)" -PasswordProfile $PasswordProfile -UserPrincipalName "$FirstName$LastName@$MyDomain" -Givenname $FirstName -Surname "$LastName (External)" -AccountEnabled $true -MailNickName "EXT"
Start-Sleep -Seconds 5
Set-AzureADUser -ObjectID "$FirstName$LastName@$MyDomain" -UserType Guest

### PROVIDE TIME FOR EXCHANGE SYNC TO OCCUR ###
Write-Output "Syncing new users to Exchange. The script will continue running after a 12 minute delay. Please do not close this window or the process will be aborted."
Start-Sleep -Seconds 720
Write-Output "User creation complete. Now updating users in Exchange"

### LOGIN TO EXCHANGE ###
Connect-ExchangeOnline -UserPrincipalName $UserName -ExchangeEnvironmentName O365USGovGCCHigh

### SWITCH TO EXCHANGE AND MARK AS GUESTS ###
Set-MailUser "$FirstName$LastName@$MyDomain" -HiddenFromAddressListsEnabled:$false -MailTip 'External B2B Guest Account' -ExternalEmailAddress "$ExternalEmail"
Write-Warning "User must have something shared with them to setup access."