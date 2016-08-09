#!/usr/bin/ksh93
################################################################
#### 
#### -R RITM0000000
#### -L Location
#### -D Domainname
#### 
################################################################

B="${WHOAMI:-$( whoami )}"
H="${HSTNAME:-$( hostname )}"
B="dlf"
H="localhost"
H=""
R="${CHGREQNUMB:-RITM000000}"
L="${LOCATION:-NYC}"
D="${DOMNAME:-mtxia.com}"
O="/tmp/checklist"

cd /usr/local/scripts/checklist-3.2

./checklist.zbksh -v ${B:+-b ${B}} ${H:+-h ${H}} -u dfrench ${R:+-R ${R}} ${L:+-L ${L}} ${D:+-D ${D}} -H -S | tee /tmp/${R}_${H%%.*}_checklist.html

