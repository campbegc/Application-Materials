# CAUTION: This script creates a list of users to disable based on a distrobution
# group name. REMOVE ADMINISTRATORS AND OTHER VIPS FROM THE LIST BEFORE USE!!!!!!


#This line allows you to put in the name of the distrobution list.
$GroupName = Read-Host '*
*
Did you remove all staff and admin from the senior class distrobution list?
*
*
If yes, What is the senior class distribution group?
*
*
Put the name in quotes: "exactSpelling" ' 


#This line grabs the member list of the distrobution list, and exports the list into a .csv file locally
 get-adgroupmember -identity "$GroupName" | select name, samaccountname | export-csv .\emailGroupExports.csv


#Calls the exported .csv, and starts a loop for each name which will move the user to the disabled OU, Remove group membership, set office to "disabled" and deactivate the account.
Import-Csv ".\emailGroupExports.csv" | ForEach-Object {
 $samAccountName = $_."samAccountName" 
            
            
            #Removes all user groups from the user's account with a loop that removes the user from each group they belong to (However, it leaves DomainUsers)
            Get-ADUser -Identity $samAccountName -Properties MemberOf | ForEach-Object {
            $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
            }GoodMorningDave.ps1 

        
            #Set "office" field to Disabled in profile
            set-aduser $samAccountName -Office "Disabled"

            #Disables User account
            Disable-ADAccount -Identity $samAccountName 
            Get-ADUser $samAccountName | Move-ADObject -TargetPath 'OU=StudentDisabledAccounts,DC=branford,DC=k12,DC=ct,DC=us'
     

            Write-Output "$name has been disabled. "
            get-aduser -Identity $samAccountName -Properties * | Select-Object DisplayName,Office,distinguishedname
            
            # Disables the account in gmail, effectively shutting down email, etc. Thus, you don't have to wait for the GADS script to run on the hour. 
            gam update user $samAccountName suspended on    

}
