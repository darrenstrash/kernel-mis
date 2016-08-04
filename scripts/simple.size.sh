#! /bin/bash

directory_name=$1
time_out=$2
binary_dir=../../bin
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in `ls -1 $directory_name/*.graph`; do

    $binary_dir/kernel-mis --experiment=kernel-size-simple --input-file=$i --table > temp_file&
    
#kill after timeout
    $script_dir/kill_timer.sh $! $time_out 
    if [ $? -eq 0 ]; then
        echo "- -"
    else
        cat temp_file | awk '{print $5}' | sed -e "s#\[##g" | sed -e "s#s\]##g"
    fi
done
