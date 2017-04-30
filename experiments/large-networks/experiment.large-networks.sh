#! /bin/bash

time_out=3600

experiment_name=large-networks
output_dir=$experiment_name.$time_out
data_dir=../../data/
script_dir=../../scripts/

rm -rf old.$output_dir
mv $output_dir  old.$output_dir
mkdir $output_dir

data_sets="konect snap law"

for data_set in $data_sets
do
    echo "Evaluating data set $data_set..."

$script_dir/graph.name.sh $data_dir/$data_set | tee $output_dir/$data_set.graph.name
$script_dir/graph.size.sh $data_dir/$data_set | tee $output_dir/$data_set.graph.size
#./critical.size.sh $data_dir/$data_set $time_out | tee $output_dir/$data_set.critical.size
#./maxcritical.size.sh $data_dir/$data_set $time_out | tee $output_dir/$data_set.maxcritical.size
$script_dir/simple.size.sh $data_dir/$data_set $time_out | tee $output_dir/$data_set.simple.size
$script_dir/simple.solution.sh $data_dir/$data_set $time_out | tee $output_dir/$data_set.simple.solution
$script_dir/advanced.size.sh $data_dir/$data_set $time_out | tee $output_dir/$data_set.advanced.size
$script_dir/advanced.solution.sh $data_dir/$data_set $time_out| tee $output_dir/$data_set.advanced.solution

done

cp header.$experiment_name $output_dir/
cp footer.$experiment_name $output_dir/

cp mk_large_networks_table_data.py $output_dir/
cd $output_dir
cat header.$experiment_name > $experiment_name.table.tex
python mk_large_networks_table_data.py >> $experiment_name.table.tex
cat footer.$experiment_name >> $experiment_name.table.tex
