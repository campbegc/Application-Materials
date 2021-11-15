
#Adds a single user to the AdobeUsers user group in order to give them adobe privleges. 
$User = read-host "Who is the user?"
Add-ADGroupMember -Identity AdobeUsers -Members $User