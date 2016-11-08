#!/bin/bash

rmtHost=$1
rmtPort=$2

vTempFile=$(mktemp)
vTimeout=5


echo "My Network Configuration"
echo "------------------------"

for vNIC in $(ip a s | sed -n '/^[0-9]\+: /{s///;s/:.*//p;}')
do
   echo -e "Interface [${vNIC}] IP Address = $(ip a s ${vNIC} | sed -nr '/^[[:space:]]*inet /{s///;s/ .*//p;}')"
done

OIFS=${IFS}
IFS=','
echo
for PORT in ${rmtPort}
do
   echo -ne "===> Testing TCP Port ${PORT}..."
   timeout ${vTimeout} bash -c "cat < /dev/null > /dev/tcp/${rmtHost}/${PORT}"  2> ${vTempFile}
   retCode=$?
   case ${retCode} in
      '0')
         echo "OK"
         ;;
      *)
         echo "ERROR"
         echo "Return Code = ${retCode}"
         echo "Test Output:"
         cat ${vTempFile}
         echo
         ;;
   esac
done

IFS=${OIFS}

rm -f ${vTempFile}

exit
