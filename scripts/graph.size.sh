#! /bin/bash

experiment_name=$1
binary_dir=../../bin

head -1 $experiment_name | awk '{print "vertices : " $1 "\n" "edges : " $2}'
