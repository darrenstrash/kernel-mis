#! /bin/bash

make clean
make -j4

if [ ! -d data ]; then
    echo "untarring data..."
    tar -xf sample.data.tar.gz
fi

output_dir=output
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
timeout=3600

experiment_dir="$this_dir/experiments"

experiments="sanchis erdos-biogrid large-networks"
#experiments="sanchis large-networks"

echo "Running experiments and writing table output to $output_dir/table.tex"

cd $experiment_dir

rm -rf old.$output_dir
mv $output_dir  old.$output_dir
mkdir $output_dir

cat assets/header.document >> $output_dir/table.tex

for experiment_name in $experiments
do
    cd $experiment_dir/$experiment_name
    ./experiment.$experiment_name.sh
    cd $experiment_dir/
    cat $experiment_dir/$experiment_name/$experiment_name.$timeout/$experiment_name.table.tex >> $output_dir/table.tex
done

cat assets/footer.document >> $output_dir/table.tex

cp $output_dir/table.tex $this_dir/

cd $this_dir
rm table.pdf
pdflatex table
pdflatex table

rm table.aux table.log

echo "Done! Please view table.pdf"
