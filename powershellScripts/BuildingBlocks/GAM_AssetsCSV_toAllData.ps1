# This script will take a column of asset numbers, with the column labeled "asset", and produce a google sheet containing serials and other info. 
# It is a a two step script because of the way that gam handles input and output. 
# Gam can use a floating csv, but will only use one per command, thus we require the creation of a second csv to draw from for the ouput step.
# The command "Gam print cros query <query>" will result in a deviceId which can only be processed by the command "Gam info cros ~deviceId"
# Ironically, the serial number needs to be piped back into the "gam print cros query" command to produce a spreadsheet of useful info. 

# For reference: 
# Gam print syntax:
# gam print cros [query <query>] [orderby location|user|lastsync|serialnumber|supportenddate] [ascending|descending] [todrive] [allfields|full|basic] [nolists] [listlimit <Number>] <CrOSFieldName>* [fields <CrOSFieldNameList>]

# Gam info syntax
# gam info cros <device id> [allfields|full|basic] [nolists] [listlimit <Number>] <CrOSFieldName>* [fields <CrOSFieldNameList>] [downloadfile latest|<id>] [targetfolder <path>]


Write-Output "Put the csv file in the same directory as the script."
Write-Output "The output file will be a google sheet."

$Filename = Read-Host "What is the csv filename? exclude '.csv'"


gam csv $Filename.csv gam print cros query ~asset | gam csv - gam info cros ~deviceID basic > GAMINFO.csv

gam csv GAMINFO.csv gam print cros ~serialNumber todrive full no lists

remove-item GAMINFO.csv


#Or, instead of all this, you can put the data into columns using gopher, export to an office 365 excell sheet, and use xlookup. It's way easier than vlookup. That depends on having gopher still through. GAM is free. 