#!/usr/bin/ksh

if ! [ -r "$1" ]; then
        echo "Specify name of input CSV file on command line"
        exit 1
fi


cat "$1" | grep ^/ | while read line; do
        mount="`echo $line | awk -F, '{print $1}'"
        lv="`echo $line | awk -F, '{print $2}'"
        size="`echo $line | awk -F, '{print $3}'"
        vg="`echo $line | awk -F, '{print $4}'"
        user="`echo $line | awk -F, '{print $5}'"
        group="`echo $line | awk -F, '{print $6}'"
        perm="`echo $line | awk -F, '{print $7}'"
        options="`echo $line | awk -F, '{print $8}'"
        log="`echo $line | awk -F, '{print $9}'"

        echo "( mkdir -p $mount &&"
        echo "mklv -y $lv -t jfs2 -L $lv $vg ${size}G &&"
        myoptions=""
        mylog=""
        ! [ -z "$options" ] && myoptions="-a options=`echo $options | tr '.' ',' | tr -d ' '`"
        ! [ -z "$log" ] && mylog="-a logname=$log"
        echo "crfs -v jfs2 -d $lv -m $mount -A yes -p rw $myoptions $mylog &&"
        echo "mount $mount &&"
        echo "chown ${user}:${group} $mount &&"
        echo "chmod $perm $mount ) &&"
        echo "echo \"$mount created successfully\" ||"
        echo "echo \"ERROR creating $mount\""
        echo "echo"
        echo
done
