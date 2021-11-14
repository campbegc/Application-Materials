$User = Read-Host 'Which user?' 
get-aduser $User -properties * | Select DisplayName, Name, Office, title, ExtensionAttribute10, employeeid, PasswordNeverExpires