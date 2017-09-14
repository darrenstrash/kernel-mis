#! /usr/bin/python

import sys
import os
sys.path.append("../../")
from table_gen import *

same_keys_list = []
different_keys_list = []
keys_list = ["graph-name"]
#[data, type, operation, formating]
columns_list = [("vertices", "int"), ("edges", "int"), ("simple-set-k", "int"), ("simple-solution", "float")]
title = "Results of Large Networks Experiments"
author = "Darren Strash, Daniel Gathogo (automated)"
column_heads = [("Graph", 3), ("Simple+MCS", 2)]
#column_heads = [] #empty for non publication table
column_names = ["Name", "n", "m", "k", "t"] #start with names for each key in keys_list

compare_cols = [] #highlight max or min, zero-indexed count in column_names
experiment_name = "Large-Networks"
experiments = ["law", "snap", "konect"]
sub_headers = ["LAW Graphs", "SNAP Graphs", "KONECT Graphs"]
table_format = "latex_publication" #latex, latex_publication, markdown
caption = "We give the size kmax of largest connected component in the kernel from each reduction technique and the running time t of each algorithm to compute an exact maximum independent set. We further give the number of vertices n and edges m for each graph."

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
