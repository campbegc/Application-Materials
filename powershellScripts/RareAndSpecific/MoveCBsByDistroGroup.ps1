
#Allows user to specify which distro group to pull users from, and which OU to place their chromebooks. 
$group = read-host "Which distrobution group are we shutting down? (spaces matter; exactly as in AD)"
$location = read-host "what is path of the OU you want to sent the chromebooks to? /LostChromebooks?"

#creates a csv for GAM to read users from. Haven't figured out how to pipe directly into GAM, b/c of the column label output. 
get-adgroupmember -identity "$group" | select SAMAccountName > temp.csv

#Reads csv for users, grabs chromebooks based on username, moves them to desired OU.
gam csv temp.csv gam print cros query "user:~SAMAccountName" | gam csv - gam update cros ~deviceId ou $location