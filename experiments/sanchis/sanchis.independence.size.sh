#! /bin/bash

directory_name=$1

for i in `ls -1 $directory_name/*.graph`; do

    echo $i | sed -e "s#.*/##g" | sed -e 's#sanchis-[0-9]*-\([0-9]*\).graph#\1#g'

done
