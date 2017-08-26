#! /bin/bash

time_out=3600
seeds=5
seeds_minus_one=$((seeds - 1))

data_dir=../../data
script_dir=../../scripts

experiments=(erdos biogrid)

for item in ${experiments[*]}; do
  output_dir=$item
  rm -rf old.$output_dir
  mv $output_dir  old.$output_dir
  mkdir $output_dir
  data_set=$data_dir/$item
  
  for file_name in `ls -1 $data_set/*.graph`; do
    temp=${file_name##*/}
    temp=${temp%.*}
    graph_name=$($script_dir/graph.name.sh $file_name)
    graph_size=$($script_dir/graph.size.sh $file_name)

    for seed in $(seq 0 $seeds_minus_one); do
      log_file=$output_dir/log.$temp.$seed
      $script_dir/critical.size.sh      $file_name $time_out | tee -a $log_file
      $script_dir/maxcritical.size.sh   $file_name $time_out | tee -a $log_file
      $script_dir/simple.size.time.sh   $file_name $time_out | tee -a $log_file
      $script_dir/advanced.size.time.sh   $file_name $time_out | tee -a $log_file
      echo "$graph_size" >> $log_file
      echo "$graph_name" >> $log_file
    done
  done
done

python tablegen.py
