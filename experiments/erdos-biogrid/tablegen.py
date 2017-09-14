#! /usr/bin/python

import sys
import os
sys.path.append("../../")
from table_gen import *

same_keys_list = []
different_keys_list = []
keys_list = ["graph-name"]
#[data, type, operation, formating]
columns_list = [("vertices", "int"), ("edges", "int"), ("critical-set-k", "int"), ("critical-set-time", "float"), ("maxcritical-set-k", "int"), ("maxcritical-set-time", "float"), ("simple-set-k", "int"), ("simple-set-time", "float")]
title = "Results of Erdos and BioGRID Experiments"
author = "Darren Strash, Daniel Gathogo (automated)"
column_heads = [("Graph", 3), ("Critical", 2), ("Maxcritical", 2), ("Simple", 2)]
#column_heads = [] #empty for non publication table
column_names = ["Name", "n", "m", "k", "t", "k", "t", "k", "t"] #start with names for each key in keys_list

compare_cols = ["min", 4, 6] #highlight max or min, zero-indexed count in column_names
experiment_name = "Erdos-BioGRID"
experiments = ["erdos", "biogrid"]
sub_headers = ["Erdos Graphs", "BioGRID Graphs"]
table_format = "latex_publication" #latex, latex_publication, markdown
caption = "We give the kernel size k and running time t for each reduction technique on synthetically- generated Sanchis data sets. We also list the data used to generate the graphs: the number of vertices n, number of edges m, and independence number q(G)."

data_dir = os.getcwd()
table = table_writer()
table.initialize(experiment_name, table_format, title, author) #packages-optional last argument
for i in range(len(experiments)):
    temp_dir = data_dir + "/" + experiments[i]
    exp = data_cruncher()
    exp.process_dir(temp_dir, keys_list)
    exp.validate_data(same_keys_list, different_keys_list)
    table.add_experiment(exp, experiments[i], sub_headers[i]) #sub_headers optional

table.write_table(column_names, column_heads, columns_list, compare_cols, caption)
