#! /bin/bash

time_out=3600

output_dir=erdos-biogrid.$time_out
experiment_name=erdos-biogrid

data_dir=../../data/
script_dir=../../scripts/
erdos_data_set=$data_dir/erdos
biogrid_data_set=$data_dir/biogrid

rm -rf old.$output_dir
mv $output_dir  old.$output_dir

mkdir $output_dir

#erdos
$script_dir/graph.name.sh $erdos_data_set | tee $output_dir/erdos.name
$script_dir/graph.size.sh $erdos_data_set | tee $output_dir/erdos.graph.size
$script_dir/critical.size.sh $erdos_data_set $time_out | tee $output_dir/erdos.critical.size
$script_dir/maxcritical.size.sh $erdos_data_set $time_out | tee $output_dir/erdos.maxcritical.size
$script_dir/simple.size.time.sh $erdos_data_set $time_out | tee $output_dir/erdos.simple.size
$script_dir/advanced.size.time.sh $erdos_data_set $time_out| tee $output_dir/erdos.advanced.size

# biogrid
$script_dir/graph.name.sh $biogrid_data_set | tee $output_dir/biogrid.name
$script_dir/graph.size.sh $biogrid_data_set | tee $output_dir/biogrid.graph.size
$script_dir/critical.size.sh $biogrid_data_set $time_out | tee $output_dir/biogrid.critical.size
$script_dir/maxcritical.size.sh $biogrid_data_set $time_out | tee $output_dir/biogrid.maxcritical.size
$script_dir/simple.size.time.sh $biogrid_data_set $time_out | tee $output_dir/biogrid.simple.size
$script_dir/advanced.size.time.sh $biogrid_data_set $time_out| tee $output_dir/biogrid.advanced.size

cp header.erdos-biogrid $output_dir/
cp footer.erdos-biogrid $output_dir/

cp mk_erdos_biogrid_table_data.py $output_dir/
cd $output_dir
cat header.$experiment_name > erdos-biogrid.table.tex
python mk_erdos_biogrid_table_data.py >> erdos-biogrid.table.tex
cat footer.$experiment_name >> erdos-biogrid.table.tex
