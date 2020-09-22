#!/bin/bash



cp StatTable.csv report.csv
sed -i "s/^\(\s*,\)*\s*$//g" report.csv
sed -i "/^\s*$/d" report.csv
