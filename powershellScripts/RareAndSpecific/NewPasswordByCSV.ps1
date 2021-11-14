$Resetpassword = Import-Csv "C:\users\gcampbell\desktop\Kindergarten.csv"
 #Store CSV file into $Resetpassword variable
 
foreach ($User in $Resetpassword) {
    #For each name or account in the CSV file $Resetpassword, reset the password with the Set-ADAccountPassword string below
    $User.sAMAccountName
    $User.employeeid
        Set-ADAccountPassword -Identity $User.sAMAccountName -Reset -NewPassword (ConvertTo-SecureString $User.employeeid -AsPlainText -force)
}
 Write-Host " Passwords changed "
 $total = ($Resetpassword).count
 $total
 Write-Host "Accounts passwords have been reset..."