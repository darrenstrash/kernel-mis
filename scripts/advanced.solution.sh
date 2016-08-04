#! /bin/bash

directory_name=$1
time_out=$2
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in `ls -1 $directory_name/*.snap`; do

    /home/strash/java/jdk1.8.0_60/bin/java -cp /global_data/strash/reduction-exact-mis-experiments/branch-and-reduce/bin Main $i > temp_file&

    #kill after timeout
    $script_dir/kill_timer.sh $! $time_out 
    if [ $? -eq 0 ]; then
        echo "-"
    else
        cat temp_file | awk '{print $4}'
    fi
done
