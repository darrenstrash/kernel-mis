#! /bin/bash

time_out=3600
seeds=5
seeds_minus_one=$((seeds - 1))

output_dir=sanchis.$time_out

data_dir=../../data_2/
script_dir=../../scripts/
sanchis_data_set=$data_dir/sanchis

rm -rf old.$output_dir
mv $output_dir  old.$output_dir

mkdir $output_dir
for file_name in `ls -1 $sanchis_data_set/*.graph`; do
  temp=${file_name##*/}
  temp=${temp%.*}
  graph_size=$($script_dir/graph.size.sh $file_name)
  independence_size=$(./sanchis.independence.size.sh $file_name)

  for seed in $(seq 0 $seeds_minus_one); do
    log_file=$output_dir/log.$temp.$seed
    $script_dir/critical.size.sh      $file_name $time_out | tee -a $log_file
    $script_dir/maxcritical.size.sh   $file_name $time_out | tee -a $log_file
    $script_dir/simple.size.time.sh   $file_name $time_out | tee -a $log_file
    echo "$graph_size" >> $log_file
    echo "$independence_size" >> $log_file
  done
done

python tablegen.py
