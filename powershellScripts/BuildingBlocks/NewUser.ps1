$name = Read-Host "What is the username?"
$Given = Read-Host "What is the first name?"
$Surname = Read-Host "What is the last name?"
$password = Read-Host "What is their password?" 

# Creates the new user
New-ADUser -Name "$name" -EmailAddress "$name@branfordschools.org" -DisplayName "$name" -PasswordNeverExpires $true -SamAccountName "$name" -Surname "$Surname" -GivenName "$Given" -AccountPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) -UserPrincipalName "$name@branfordschools.org"

#Enabled Account
Enable-ADAccount -Identity "$name"

#Forces user password
Set-ADAccountPassword -Identity $name  -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)

#Adds user to GoogleApps so they show up
Add-ADGroupMember -identity GoogleApps -Members $name

#Adds user to another distrobution/security group if requested
$group = Read-Host "Add user to another distro/secuirty group Y/N?"
if ($group -eq 'Y'){
$distro = Read-Host "What group do you want to add the user to? (just the name, no @branfordschools.org)"
Add-ADGroupMember -Identity $distro -Members $name} 
else {Write-Output "Okay, all done!"}  

