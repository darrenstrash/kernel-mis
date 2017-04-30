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

            #print "\"" + row[index] + "\""
            if index in [3,5,7,9]:
                if int(row[index]) < min_kernel:
                    min_kernel = int(row[index])

            if index in [4,6,8,10]:
                if float(row[index]) < min_time:
                    min_time = float(row[index])

        for index in range(0,len(row)):
            make_bold=0

            if row[index] == '-' or row[index] == 'Missing':
                continue

            if index in [3,5]:
                make_bold=(int(row[index]) == min_kernel)

            if index in [4,6]:
                make_bold=(abs(float(row[index]) - min_time) < 0.001)

            if index != 0:
                row[index] = '\\numprint{' + row[index] + '}'

                if make_bold == 1:
                    row[index] = '\\textbf{' + row[index] + '}'



def read_and_format_rows(data_set_name, rows):
    read_in_columns(data_set_name + '.graph.name',        rows)
    read_in_columns(data_set_name + '.graph.size',       rows)
#    read_in_columns(data_set_name + '.critical.size',    rows)
#    read_in_columns(data_set_name + '.maxcritical.size', rows)
    read_in_columns(data_set_name + '.advanced.size',    rows)
    read_in_columns(data_set_name + '.advanced.solution',rows)
    read_in_columns(data_set_name + '.simple.size',      rows)
    read_in_columns(data_set_name + '.simple.solution',  rows)
    format_numbers(rows)



def print_rows(data_set_name, rows, last):
    pattern = re.compile('.*\{(.*\d)\}')

    num_columns = 7
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
law_rows = []
snap_rows = []
konect_rows = []

read_and_format_rows('law'   , law_rows)
read_and_format_rows('snap'  , snap_rows)
read_and_format_rows('konect', konect_rows)

print_rows("LAW Graphs"   , law_rows   ,    0)
print_rows("SNAP Graphs"  , snap_rows  ,    0)
print_rows("KONECT Graphs", konect_rows,    1)

#print rows

