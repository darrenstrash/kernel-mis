#! /bin/bash

experiment_name=$1
echo -n "independence_number : "
echo $experiment_name  | sed -e "s#.*/##g" | sed -e 's#sanchis-[0-9]*-\([0-9]*\).graph#\1#g'
