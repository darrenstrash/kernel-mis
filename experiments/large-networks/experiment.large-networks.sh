#! /bin/bash

time_out=3600

experiment_name=large-networks
data_dir=../../data/
script_dir=../../scripts/

data_sets="snap konect law"

for item in $data_sets; do
  echo "Evaluating data set $item..."
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
    log_file=$output_dir/log.$temp

    #./critical.size.sh $data_dir/$item $time_out | tee $output_dir/$item.critical.size
    #./maxcritical.size.sh $data_dir/$item $time_out | tee $output_dir/$item.maxcritical.size
    $script_dir/simple.size.sh     $file_name $time_out | tee -a $log_file
    $script_dir/simple.solution.sh   $file_name $time_out | tee -a $log_file
    $script_dir/advanced.size.sh   $file_name $time_out | tee -a $log_file
    $script_dir/advanced.solution.sh  $file_name $time_out | tee -a $log_file
    echo "$graph_size" >> $log_file
    echo "$graph_name" >> $log_file
  done
done

python tablegen.py
