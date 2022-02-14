#!/bin/bash
#!/home/gareth/bin/gam/gam
gam="/home/gareth/bin/gam/gam"
# Project: Produce a csv that lists the lists the chromebooks that don't have matching annotated users and recent users

## call all chromebooks
$gam print cros orderby lastsync full listlimit 1 >cros.csv

## sort columns of data into other file
## 2/14/2022 Double check that the order of CSV columns, As GAM updates, it has been shown to change with time. 
awk -F , '{if ($6 == "bpsdeprovisioned@branfordschools.org"); 
    else if ($6 == "holding@branfordschools.org"); 
    else if ($6 == "shorelineadulted@branfordschools.org");
    else if ($26 == "/LostChromebooks");
    else if ($6 != $29) print $6","$29","$4","$31","$26}' cros.csv > temp.csv



## re-order data so that all the "holding@branfordschools.ord" emails are at the bottom, or even truncated

sort -t, -dk1 temp.csv > MisMatches.csv
rm ./temp.csv
rm ./cros.csv
