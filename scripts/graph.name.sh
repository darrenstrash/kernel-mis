#! /bin/bash

directory_name=$1

for i in `ls -1 $directory_name/*.graph`; do

    echo $i | sed -e "s#.*/##g" | sed -e "s#\.edges##g" | sed -e "s#\.graph##g" | sed -e "s#\.snap##g" | sed -e "s#-3\.3\.122##g" | sed -e "s#-uniq##g" | sed -e "s#zhishi-##g" | sed -e "s#-friendships##g" | sed -e "s#-relationships##g" | sed -e "s#Immunodeficiency-Virus#HIV#g"

done
