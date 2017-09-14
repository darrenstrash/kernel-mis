#! /usr/bin/python

import sys
import os
from table_gen import *

same_keys_list = []
different_keys_list = []
keys_list = ["vertices", "edges", "independence_number"]
#[data, type, operation, formating]
columns_list = [("critical-set-k", "int"), ("critical-set-time", "float"), ("critical-set-time", "float", "average"), ("maxcritical-set-k", "int"), ("maxcritical-set-time", "float"), ("maxcritical-set-time", "float", "average"), ("simple-set-k", "int"), ("simple-set-time", "float"), ("simple-set-time","float", "average")]
title = "Results of Sanchis Experiments"
author = "Darren Strash, Daniel Gathogo (automated)"
column_heads = [("Graph", 3), ("Critical", 3), ("Maxcritical", 3), ("Simple", 3)]
#column_heads = [] #empty for non publication table
column_names = ["n", "m", "q(G)", "k", "t","t-avg", "k", "t","t-avg", "k", "t", "t-avg"] #start with names for each key in keys_list

compare_cols = ["min", 4, 7, 10] #highlight max or min, zero-indexed count in column_names
experiment_name = "Sanchis"
experiments = ["sanchis"]
sub_headers = [] #subheadings for each experiment
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
    table.add_experiment(exp, experiments[i]) #sub_headers[i] optional

table.write_table(column_names, column_heads, columns_list, compare_cols, caption)
