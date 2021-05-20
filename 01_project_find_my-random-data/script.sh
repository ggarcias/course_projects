#!/bin/bash

# 1) Find the file my_random_data.txt inside the directory tree of "find_the_file"
my_random_data_path=$(find ./find_the_file -name my_random_data.txt);
echo "my_random_data.txt is located at: ${my_random_data_path}"

# 2) Detect all the zeros inside the data
grep "0" $my_random_data_path;

# 3+4) Count how many zeros there are + print the result
count_of_0=$(grep -o "0" $my_random_data_path | wc -w);
echo "There are ${count_of_0} times '0' in my_random_data.txt"
