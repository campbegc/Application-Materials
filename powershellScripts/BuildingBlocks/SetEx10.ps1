$User = Read-Host 'Which user?' 
$NewNumber = Read-Host 'The new number is?'
set-aduser $User -replace @{extensionattribute10=" $NewNumber"}