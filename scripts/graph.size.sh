#! /bin/bash

directory_name=$1
binary_dir=../../bin

for i in `ls -1 $directory_name/*.graph`; do

    head -1 $i | awk '{print $1 " " $2}'

done
