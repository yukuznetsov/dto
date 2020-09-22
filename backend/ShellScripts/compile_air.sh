#!/bin/bash

typeset -t out_file=air.csv
typeset -t header_file=air_header.csv
typeset -t temp_file=temp.csv





cat AirTable_1.csv >  "$out_file"
cat AirTable_2.csv >> "$out_file"
cat AirTable_3.csv >> "$out_file"
cat AirTable_4.csv >> "$out_file"
cat AirTable_5.csv >> "$out_file"

sed -i "s/^\(\s*,\)*\s*$//g" "$out_file"
sed -i "s/^.*\[\[[a-zA-Z0-9_ -]\+\]\].*$//g" "$out_file"
sed -i "/^\s*$/d" "$out_file"


cat "$out_file" | sort -t ',' -k2 > "$temp_file"

cat "$header_file" > "$out_file"
awk -e 'BEGIN{cnt = 1;} {print cnt$0; ++cnt;}' temp.csv >> "$out_file"

