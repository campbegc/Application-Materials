$name = Read-Host 'Which distribution group? (exact spelling)' 

 get-adgroupmember -identity "$name" | select name, samaccountname | export-csv .\emailGroupExports.csv