$user = Read-Host 'Enter account name' 

Set-ADuser -Identity $user  -PasswordNeverExpires $true


