$OUpath = 'OU=Students,OU=BHS,DC=branford,DC=k12,DC=ct,DC=us'
$ExportPath = 'c:\users\gcampbell\desktop\UsersByOU.csv'
Get-ADUser -Properties * -Filter * -SearchBase $OUpath | Select-object employeeid,samaccountname,emailaddress,displayname | Export-Csv -NoType $ExportPath