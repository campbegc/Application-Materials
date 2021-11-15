#Menu of constantly used, or substantially complex/time consuming functions.

# Main menu description and options.
#==================================================================
function Show-Menu {
    param (
        [string]$Title = "Good Morning, Paul. What will your first sequence of the day be?",
        [string]$ChromeTitle = "Chromebook Admin functions",
        [string]$UserTitle = "AD Account Functions",
        [string]$GuardianTitle = "Google Classroom Guardian Settings"
    )
    Clear-Host
    Write-Host "===$Title==="
    Write-Host ""
    Write-Host "===$UserTitle==="
    Write-Host ""
    Write-Host "1: User Lookup"
    Write-Host "2: Search computer logins logs"
    Write-Host "3: Reset Password"
    Write-Host "4: Set Password Never Expires"
    Write-Host "5: Set Ext10 value"
    Write-Host "6: Disable Account"
    Write-Host "7: Rename Computer"
    Write-Host "8: Add User to Adobe users group"
    Write-Host ""
    Write-Host "===$ChromeTitle==="
    Write-Host ""
    Write-Host "9: General Search (Asset# or Serial#)"
    Write-Host "10: Search devices by annotated username"
    Write-Host "11: Move annotated user's chromebooks to /LostChromebooks"
    Write-Host "12: Move to /LostChromebooks by 5-digit asset or serial"
    Write-Host "13: Update Annotated User for device"
    Write-Host "14: Move multiple to specific OU by User Group"
    Write-Host ""
    Write-Host "===$GuardianTitle==="
    Write-Host ""
    Write-Host "15: Show Student's Invited Guardians"
    Write-Host "16: Delete Student Guardians"
    Write-Host "17: Invite New Guardians"
    Write-Host ""
    Write-Host "Q: press 'Q' to quit."
    Write-Host ""
}

#Do/Until loop with subscripts are found below
#===============================================================

do {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        #USER LOOKUP
        1 { $User = Read-Host 'Which user?'
            get-aduser $User -properties * | Select-Object DisplayName, Name, Office, title, ExtensionAttribute10, employeeid, employeetype, PasswordNeverExpires, distinguishedname, memberof }
        #SEARCH LOGON LOGS OF COMPUTERS. LOGS ARE PRODUCED ONLY WHEN CONNECTED TO OUR PHYSICAL NETWORK.
        2 { $Query = Read-Host 'Please supply the username, asset number, or serial'
            Get-Childitem -Path \\bhsfs\SharedData\Technology\LoginLogs -Filter *$Query* -File -Recurse -ErrorAction SilentlyContinue | Get-Content}
        #RESET PASSWORD
        3 { $user = Read-Host 'Enter account name'
            $password = Read-Host 'Enter New Password'
            Set-ADAccountPassword -Identity $user  -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) }
        #PASSWORD NEVER EXPIRES
        4 { $user = Read-Host 'Enter account name'
            Set-ADuser -Identity $user  -PasswordNeverExpires $true }
        #SET EXT10 ON ACCOUNT
        5 { $User = Read-Host 'Which user?'
            $NewNumber = Read-Host 'The new number is?'
            set-aduser $User -replace @{extensionattribute10=" $NewNumber" }}
        #DISABLE ACCOUNT
        6 { $name = Read-Host "What is the username of the terminated staffmember?"
            $staff = Read-Host "Is this a staff member? Y/N"

            #Moves the user into the disabled staff OU
            if ($staff -eq 'Y') { Get-ADUser $name| Move-ADObject -TargetPath 'OU=StaffDisabledAccounts,DC=branford,DC=k12,DC=ct,DC=us'}
            else { Get-ADUser $name| Move-ADObject -TargetPath 'OU=StudentDisabledAccounts,DC=branford,DC=k12,DC=ct,DC=us'}
            
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
            Write-Output " "
            Write-Output "==========================================================================="
            Write-Output " "

            Write-Output "$name has been disabled. "
            get-aduser -Identity $name -Properties * | Select-Object DisplayName,Office,distinguishedname
            
            # Disables the account in gmail, effectively shutting down email, etc. Thus, you don't have to wait for the GADS script to run on the hour. 
gam update user $name suspended on    
                }
        #RENAME COMPUTER - REQUIRES EXACT NAME
        7 {$computer = read-host "What is the old computer name?"
            $name = Read-Host "What is the new computer name?"
            rename-computer -computername "$computer" -NewName "$name" -DomainCredential branford.k12.ct.us\gcampbell -force -Restart}

        #ADD USER TO ADOBEUSERS GROUP SO THEY CAN USE CREATIVE CLOUD.
        8 {$User = read-host "Who is the user?"
            Add-ADGroupMember -Identity AdobeUsers -Members $User}

        #GENERAL CHROMEBOOK SEARCH (FOR NUMBERS. USERNAMES WILL RETURN ALL CHROMEBOOKS A USER HAS SIGNED INTO)
        9 { $asset = Read-Host "What info on the chromebook do you have?"
            gam print cros query $asset | gam csv - gam info cros ~deviceId fields annotateduser, orgUnitPath, annotatedassetid, annotatedlocation, lastsync, serialnumber, status, model, osversion}
        #SEARCH CHROMEBOOKS BY ANNOTATED USER NAME
        10 { $User = Read-Host "Show chromebooks for which user?"
            gam print cros query "user:$User" | gam csv - gam info cros ~deviceId fields annotateduser, orgUnitPath, annotatedassetid, annotatedlocation, lastsync, serialnumber, status, model, osversion}
        #MOVE TO /LOSTCHROMEBOOKS BY USER
        11 { $user = read-host "Which user's chromebook are we moving?"
            gam print cros query "user:$user" | gam csv - gam update cros ~deviceId ou /LostChromebooks }
        #MOVE CHROMEBOOKS TO /LOSTCHROMEBOOKS BY DEVICE ID OR SERIAL
        12 { $asset = Read-Host "Enter the Serial Number or DeviceId. Asset numbers can move multiple devices"
            gam print cros query $asset | gam csv - gam update cros ~deviceId ou /LostChromebooks }
        #UPDATE ANNOTATED USER FOR CHROMEBOOK
        13 { $asset = read-host "Which Chromebook? 5-digit asset number or serial for precision"
             $User = read-host "Which user? Full email address please"
             gam print cros query $asset | gam csv - gam update cros ~deviceId user $User  }
        #MOVE MULTIPLE CHROMEBOOKS TO SPECIFIC OU BY USERGROUP
        14 { #Allows user to specify which distro group to pull users from, and which OU to place their chromebooks.
            $group = read-host "Which distrobution group are we shutting down? (spaces matter; exactly as in AD)"
            $location = read-host "what is path of the OU you want to sent the chromebooks to? /LostChromebooks?"
            
            #creates a csv for GAM to read users from. Haven't figured out how to pipe directly into GAM, b/c of the column label output.
            get-adgroupmember -identity "$group" | Select-Object SAMAccountName > temp.csv
            
            #Reads csv for users, grabs chromebooks based on username, moves them to desired OU.
            gam csv temp.csv gam print cros query "user:~SAMAccountName" | gam csv - gam update cros ~deviceId ou $location }
        #SHOW STUDENT'S INVITED GUARDIANS
        15 { $student = Read-Host "What is the student email address?"
            gam print guardians student $student todrive }
        #DELETE STUDENT GUARDIANS
        16 { $parent = Read-Host "What is the guardian email address that needs to be removed?"
            $student = Read-Host "What is the student email address?"
            gam delete guardian $parent $student }
        #INVITE NEW GUARDIANS FOR STUDENT
        17 { $parent = Read-Host "What is the guardian email address?"
            $student = Read-Host "What is the student email address?"
            gam create guardianinvite $parent $student }


        
    } 
Pause }until ($selection -eq 'q')