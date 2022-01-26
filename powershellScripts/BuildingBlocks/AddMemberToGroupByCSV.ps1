$GroupName = Read-Host "To which group are you adding members?"

import-csv .\emailGroupExports.csv | foreach {Add-ADGroupMember -Identity "$GroupName" -Members $_.SamAccountName}