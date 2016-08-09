#!/bin/bash
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
H=""
R="${CHGREQNUMB:-RITM000000}"
L="${LOCATION:-NYC}"
D="${DOMNAME:-mtxia.com}"
O="/tmp/checklist"

cd /usr/local/scripts/checklist-3.2 >/dev/null 2>&1

./checklist.bash -v ${B:+-b ${B}} ${H:+-h ${H}} ${R:+-R ${R}} ${L:+-L ${L}} ${D:+-D ${D}} -H -S -1 -2 | tee /tmp/${R}_${H%%.*}_checklist.html

