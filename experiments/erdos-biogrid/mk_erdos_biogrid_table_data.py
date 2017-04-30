#! /usr/bin/python

import sys
import re

def read_in_columns(file_name, rows):
    critical_kernel_file = open(file_name, 'r')

    first_file=(len(rows)==0)

    index=0
    for line in critical_kernel_file:
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


def format_numbers(rows):
    for row in rows:

        min_time = sys.maxint
        min_kernel = float('inf')

        for index in range(0,len(row)):
            if row[index] == '-' or row[index] == 'Missing':
                continue

            if index in [3,5,7,9]:
                if int(row[index]) < min_kernel:
                    min_kernel = int(row[index])

                if int(row[index]) == min_kernel and float(row[index+1]) < min_time:
                    min_time = float(row[index+1])


        for index in range(0,len(row)):

            if row[index] == '-' or row[index] == 'Missing':
                continue

            if index in [3,5,7,9]:
                make_kernel_bold = (int(row[index]) == min_kernel)
                make_time_bold   = (make_kernel_bold and (abs(float(row[index+1]) - min_time) < 0.001))

                row[index] = '\\numprint{' + row[index] + '}'
                row[index+1] = '\\numprint{' + row[index+1] + '}'

                if make_kernel_bold == 1:
                    row[index] = '\\textbf{' + row[index] + '}'

                if make_time_bold == 1:
                    row[index+1] = '\\textbf{' + row[index+1] + '}'
            elif index < 3 and index > 0:
                row[index] = '\\numprint{' + row[index] + '}'



def read_and_format_rows(data_set_name, rows):
    read_in_columns(data_set_name + '.name',        rows)
    read_in_columns(data_set_name + '.graph.size',       rows)
    read_in_columns(data_set_name + '.critical.size',    rows)
    read_in_columns(data_set_name + '.maxcritical.size', rows)
    read_in_columns(data_set_name + '.advanced.size',    rows)
    read_in_columns(data_set_name + '.simple.size',      rows)
    format_numbers(rows)



def print_rows(data_set_name, rows, last):
    pattern = re.compile('.*\{(.*\d)\}')

    if len(rows) > 0:
        num_columns = len(rows[0])
    sys.stdout.write("\\multicolumn{" + str(num_columns) + "}{l}{\\bf{" + data_set_name + "}} \\\\[2pt]")
    for row in rows:
        print ""
        m = pattern.match(row[1])
        if m and int(m.group(1)) < 100:
            continue
        sys.stdout.write("&".join(row) + " \\\\")
    if last == 1 or len(rows) == 0:
        print ""
    else:
        print "[8pt]"


# read data sets into the rows
erdos_rows = []
biogrid_rows = []

read_and_format_rows('erdos'  , erdos_rows)
read_and_format_rows('biogrid', biogrid_rows)

print_rows("Erd\\H{o}s Graphs", erdos_rows,   0)
print_rows("BioGRID Graphs"   , biogrid_rows, 1)

#print rows

