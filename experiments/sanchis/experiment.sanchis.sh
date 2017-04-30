#! /bin/bash

time_out=3600

output_dir=sanchis.$time_out

data_dir=../../data/
script_dir=../../scripts/
sanchis_data_set=$data_dir/sanchis

rm -rf old.$output_dir
mv $output_dir  old.$output_dir

mkdir $output_dir

$script_dir/graph.size.sh         $sanchis_data_set           | tee $output_dir/sanchis.graph.size
./sanchis.independence.size.sh    $sanchis_data_set           | tee $output_dir/sanchis.independence.size
$script_dir/critical.size.sh      $sanchis_data_set $time_out | tee $output_dir/sanchis.critical.size
$script_dir/maxcritical.size.sh   $sanchis_data_set $time_out | tee $output_dir/sanchis.maxcritical.size
$script_dir/simple.size.time.sh   $sanchis_data_set $time_out | tee $output_dir/sanchis.simple.size
$script_dir/advanced.size.time.sh $sanchis_data_set $time_out | tee $output_dir/sanchis.advanced.size

cp header.sanchis $output_dir/
cp footer.sanchis $output_dir/
cp mk_sanchis_table_data.py $output_dir/

cd $output_dir
cat header.sanchis > sanchis.table.tex
python mk_sanchis_table_data.py >> sanchis.table.tex
cat footer.sanchis >> sanchis.table.tex
