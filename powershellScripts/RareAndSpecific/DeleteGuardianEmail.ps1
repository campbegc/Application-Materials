$parent = Read-Host "What is the guardian email address that needs to be removed?" 
$student = Read-Host "What is the student email address?"

gam delete guardian $parent $student
