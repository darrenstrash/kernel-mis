#! /usr/bin/python

import sys

def read_in_columns(file_name, rows):
    sanchis_file = open(file_name, 'r')

    first_file=(len(rows)==0)

    index=0
    for line in sanchis_file:
        if first_file != 1 and index >= len(rows):
            print "ERROR! Received too many rows from " + file_name
            sys.exit(1)

        if first_file:
            rows.append(line.strip().split())
        else:
            rows[index].extend(line.strip().split())

        index = index + 1

    if index == 0 and "advanced" in file_name:
        while index < len(rows):
            rows[index].append("Missing")
            rows[index].append("Missing")
            index = index + 1

    if index != len(rows):
        print "ERROR! Received too few rows from " + file_name
        sys.exit(1)


rows = []
read_in_columns('sanchis.graph.size',        rows)
read_in_columns('sanchis.independence.size', rows)
read_in_columns('sanchis.critical.size',     rows)
read_in_columns('sanchis.maxcritical.size',  rows)
read_in_columns('sanchis.advanced.size',     rows)
read_in_columns('sanchis.simple.size',       rows)


for row in rows:

    min_time = sys.maxint
    min_kernel = float('inf')

    for index in range(0,len(row)):
        if row[index] == '-' or row[index] == "Missing":
            continue

        if index in [3,5,7,9]:
            if int(row[index]) < min_kernel:
                min_kernel = int(row[index])

            if int(row[index]) == min_kernel and float(row[index+1]) < min_time:
                min_time = float(row[index+1])

    for index in range(0,len(row)):
        if row[index] == '-' or row[index] == "Missing":
            continue

        if index in [3,5,7,9]:
            make_kernel_bold = (int(row[index]) == min_kernel)
            make_time_bold   = (make_kernel_bold and (abs(float(row[index+1]) - min_time) < 0.001))
            row[index] = '\\numprint{' + row[index] + '}'
            row[index+1] = '\\numprint{' + row[index+1] + '}'

            if make_kernel_bold==1:
                row[index] = '\\textbf{' + row[index] + '}'
            if make_time_bold==1:
                row[index+1] = '\\textbf{' + row[index+1] + '}'

        elif index < 3:
            row[index] = '\\numprint{' + row[index] + '}'

for row in rows:
    print "&".join(row), "\\\\"

#print rows

