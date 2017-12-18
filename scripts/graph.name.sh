#! /bin/bash

experiment_name=$1

echo -n "graph-name : "
echo $experiment_name | sed -e "s#.*/##g" | sed -e "s#\.edges##g" | sed -e "s#\.graph##g" | sed -e "s#\.snap##g" | sed -e "s#-3\.3\.122##g" | sed -e "s#-uniq##g" | sed -e "s#zhishi-##g" | sed -e "s#-friendships##g" | sed -e "s#-relationships##g" | sed -e "s#Immunodeficiency-Virus#HIV#g"
