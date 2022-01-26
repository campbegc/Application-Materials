#This script will produce a list of the members of any particular group in AD. The list will include Username, Email, First and Last names. 
#It will produce the output file in the directory from which it was run. 
#=======================================================================


#This requests the name of the group. The name is neccessary (not the email address). So if there are spaces, keep the spaces.
$name = Read-Host 'Which distribution group? (exact spelling)' 


#Object Oriented Programming is kind of fun. 
#This creates a variable that will be given all of the details gathered by a foreach loop. 
#The foreach loop takes each user from the group, and puts that name through the get-aduser commandlet to gather 
#the username, etc. 
 $emailList = foreach ($user in get-adgroupmember -identity "$name")
 {get-aduser -identity $user -properties * | select samaccountname, UserPrincipalName, GivenName, Surname 
 }  


 #Because the $emailList variable now contains all of the data that we need, we simply invoke it, and ask powershell to export 
 #all of its contents to a csv. 
 $emailList | export-csv .\emailGroupExports.csv
