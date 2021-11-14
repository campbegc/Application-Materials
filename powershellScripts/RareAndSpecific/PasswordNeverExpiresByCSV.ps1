$Password = Import-Csv "C:\users\gcampbell\desktop\UsersByOU.csv"
 #Store CSV file into $Password variable
 
foreach ($User in $Resetpassword) {
    #For each name or account in the CSV file $Password, set the password to never expire
    $User.sAMAccountName
    $User.employeeid
        Set-ADuser -Identity $User.sAMAccountName -PasswordNeverExpires $true
}
 Write-Host " Passwords won't expire "
 $total = ($Password).count
 $total
 Write-Host "Accounts passwords have been set to never expire..."