#!/bin/bash




cat inner_cargoes.csv  > rast-task.csv
cat extra_cargoes.csv  >> rast-task.csv
cat inner_pops.csv >> rast-task.csv
cat inner_dops.csv >> rast-task.csv
cat extra_pops.csv >> rast-task.csv
cat extra_dops.csv >> rast-task.csv
cat home_points.csv >> rast-task.csv
cat fleet.csv >> rast-task.csv

sed -i "s/^.*\[\[[a-zA-Z0-9_ -]\+\]\].*$//g" rast-task.csv
sed -i "/^\s*$/d" rast-task.csv




cat config-dto.txt > rast-config.txt 
cat conf_misc.csv >> rast-config.txt
cat conf_vehicles.csv >> rast-config.txt
cat conf_clients.csv >> rast-config.txt
sed -i "s/^.*\[\[[a-zA-Z0-9_ -]\+\]\].*$//g" rast-config.txt
sed -i "/^\s*$/d" rast-config.txt