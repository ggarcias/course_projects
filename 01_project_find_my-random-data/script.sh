#!/bin/bash

# 1) Find the file my_random_data.txt inside the directory tree of "find_the_file"
my_random_data_path=$(find ./find_the_file -name my_random_data.txt);

# 2) Detect all the zeros inside the data
grep "0" $my_random_data_path;

# 3+4) Count how many zeros there are + print the result
echo $(grep -c "0" $my_random_data_path);

