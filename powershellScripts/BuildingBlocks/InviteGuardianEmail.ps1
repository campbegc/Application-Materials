$parent = Read-Host "What is the guardian email address?" 
$student = Read-Host "What is the student email address?"

gam create guardianinvite $parent $student