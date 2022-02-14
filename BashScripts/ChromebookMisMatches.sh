#!/bin/bash
#!/home/gareth/bin/gam/gam
gam="/home/gareth/bin/gam/gam"
# Project: Produce a csv that lists the lists the chromebooks that don't have matching annotated users and recent users

## call all chromebooks
$gam print cros orderby lastsync full listlimit 1 >cros.csv

## sort columns of data into other file

awk -F , '{if ($6 == "bpsdeprovisioned@branfordschools.org"); 
    else if ($6 == "holding@branfordschools.org"); 
    else if ($6 == "shorelineadulted@branfordschools.org");
    else if ($27 == "/LostChromebooks");
    else if ($6 != $30) print $6","$30","$4","$32","$27}' cros.csv > temp.csv



## re-order data so that all the "holding@branfordschools.ord" emails are at the bottom, or even truncated

sort -t, -dk1 temp.csv > MisMatches.csv
rm ./temp.csv
rm ./cros.csv
