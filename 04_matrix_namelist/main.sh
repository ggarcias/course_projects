#!/bin/bash

# goals of this script:
# do a 1..X loop
# modify the values in parameters_matrix.list
# send a job of fortran script fortran.f90 to the nodes
# the output should be: a file named file_matrix00X.txt containing an X-sized matrix

# at the end of the script we should:
# have modified parameters_matrix.list X times
# created X file_matrix00X.txt files

# =========================================================================================================

# Loop from 1 to X
# the n° of the loop will be the n-size of the matrix & the extension of the target_file
for k in {1..5}; do

    mkdir output${k};
    for element in $(find ./ -type f); do cp ${element} output${k}; done;

    echo "loop ${k}...";
    qsub -q all.q -wd output${k} -o qsub${k}.out -e qsub${k}.err ./shell.sh ${k};

done;

echo "done.";
