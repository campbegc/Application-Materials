$name = Read-Host "What is the username of the terminated staffmember?"

#Moves the user into the disabled staff OU
Get-ADUser $name| Move-ADObject -TargetPath 'OU=StaffDisabledAccounts,DC=branford,DC=k12,DC=ct,DC=us'


#Removes all user groups from the user's account with a loop that removes the user from each group they belong to (However, it leaves DomainUsers)
Get-ADUser -Identity $name -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
}

#Adds user back to GoogleApps for Keith
Add-ADGroupMember -identity GoogleApps -Members $name

#Set "office" field to Disabled in profile
set-aduser $name -Office "Disabled"

#Disables User account
Disable-ADAccount -Identity $name 

#Prints out user account info for verification
echo " "
echo "==========================================================================="
echo " "

Echo "$name has been disabled. "
get-aduser -Identity $name -Properties * | select DisplayName,Office,distinguishedname

# Disables the account in gmail, effectively shutting down email, etc. Thus, you don't have to wait for the GADS script to run on the hour. 
gam update user $name suspended on
