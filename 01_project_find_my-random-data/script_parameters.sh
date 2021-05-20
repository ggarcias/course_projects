#!/bin/bash

# XXX = ${1} = file
# YYY = ${2} = folder (or folder path)
# ZZZ = ${3} = researched element

# 1) Find the file XXX (1st parameter) inside the directory tree of YYY (2nd parameter)
file_path=$(find ./${2} -name ${1});
echo "${1} is located at: $file_path" ;

# 2) Detect ZZZ (3rd parameter) inside the data
grep ${3} $file_path;

# 3+4) Count how many ZZZ there are + print the result
word_count=$(grep -o ${3} $file_path | wc -w);
echo "there are ${word_count} ${3} in ${1}";
