#This script can be used to make folders for the art drive. It copies the access
#control list of a folder which already contains admin and teacher permissions
#and creates a new folder for a user, and give that single user fullcontroll
#thus, no other student can muck about in there.

#NotaBene: This script needs to be in the folder that will contain the student folders. 

#Asks for the username. This will be both the file name and the username with full controll of the file.
$user = Read-host "What is the username?"

#this sets the folder from which to draw the access control list.
# Essentially, change this to the folder you want to mirror the permissions from
$folderPath = 'C:\BHS ARTS'

#This creates the new folder for the user
New-Item $user -ItemType Directory

# This grabs the current ACL referent. Note that we are using a Get-Item cmdlet
#instead of Get-ACL. This is because Get-ACL also grabs the owner info, and 
#you can't read/write to the owner field in the same command => will produce and error.
$ACL = (Get-Item $folderPath).GetAccessControl('Access')


# Creates the new access rule by adding a fullcontrol allowed field for the student user.
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$user","FullControl", "ContainerInherit,ObjectInherit","None", "Allow")

#This writes the access rule we just created to the ACL variable.
$ACL.SetAccessRule($AccessRule)

#Assigns the new rule to the folder we just created. 
$ACL | Set-Acl -Path .\$user

#creates output so you can verify that the permissions are correctly given. 
(Get-ACL -Path .\$user).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize