#! /bin/bash

experiment_name=$1
time_out=$2
binary_dir=../../bin
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$binary_dir/kernel-mis --experiment=simple-mcs --input-file=$experiment_name --table > temp_file&

#kill after timeout
$script_dir/kill_timer.sh $! $time_out
if [ $? -eq 0 ]; then
#        echo "Killed successfully..." 1>&2
#        echo -n "$i "
    echo "-"
else
#        echo -n "$i "
    grep "ERROR" temp_file 1>&2
    if [ $? -eq 1 ] &&  [ `cat temp_file | wc -w` != "0" ]; then
        cat temp_file | awk '{print "simple-solution : "$4}' | sed -e "s#\[##g" | sed -e "s#s\]##g"
    else
        cat temp_file 1>&2
#            echo "Found ERROR!" 1>&2
        echo "-"
    fi
fi
