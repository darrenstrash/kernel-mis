#! /bin/bash

output_dir=output
timeout=3600

rm -rf old.$output_dir
mv $output_dir  old.$output_dir
mkdir $output_dir

experiment_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#experiments="sanchis erdos-biogrid large-networks"
experiments="sanchis large-networks"

echo "Running experiments and writing table output to $output_dir/table.tex"

cat assets/header.document >> $output_dir/table.tex

for experiment_name in $experiments
do
    cd $experiment_dir/$experiment_name
    ./experiment.$experiment_name.sh
    cd $experiment_dir/
    cat $experiment_dir/$experiment_name/$experiment_name.$timeout/$experiment_name.table.tex >> $output_dir/table.tex
done

cat assets/footer.document >> $output_dir/table.tex

cd $output_dir
pdflatex table
pdflatex table
cd $experiment_dir

echo "Done! Please view your table $output_dir/table.pdf"
