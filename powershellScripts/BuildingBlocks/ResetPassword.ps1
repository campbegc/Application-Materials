$user = Read-Host 'Enter account name' 
$password = Read-Host 'Enter New Password'

Set-ADAccountPassword -Identity $user  -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)

