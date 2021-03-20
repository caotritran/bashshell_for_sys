#!/bin/bash

file="./domain.csv"
while IFS= read -r line
do
        grep -Fxq "$line" ./domain.list
        if [[ $? -eq 1 ]]; then
        	echo $line >> ./domain.list
        fi
done < "$file"
