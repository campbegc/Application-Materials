#Allows user to specify which distro group to pull users from, and which OU to place tthier chromebooks.
$user = read-host "Which user's chromebook are we moving?"
$location = read-host "what is path of the OU you want to sent the chromebooks to? /LostChromebooks?"

#Reads csv for users, grabs chromebooks based on username, moves them to desired OU.
gam print cros query "user:$user" | gam csv - gam update cros ~deviceId ou $location