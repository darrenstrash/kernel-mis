#! /bin/bash

experiment_name=$1
time_out=$2
binary_dir=../../bin
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$binary_dir/kernel-mis --experiment=kernel-size-critical-set --input-file=$experiment_name --table > temp_file&

#kill after timeout
$script_dir/kill_timer.sh $! $time_out
if [ $? -eq 0 ]; then
    echo "- -"
else
    cat temp_file | awk '{print "critical-set-k : "$6 "\n" "critical-set-time : " $4}' | sed -e "s#\[##g" | sed -e "s#s\]##g"
fi
