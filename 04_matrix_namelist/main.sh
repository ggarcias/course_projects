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
for k in {1..3}; do
    echo "loop n°${k}...";
    # we change the values inside the namelist file according to the loop iteration
    n=${k};
    target_file_output="\"file_matrix${k}.txt\"";

    target_file="parameters_matrix.list";
    generic_file="parameters_matrix.list.generic";

    echo "namelist:";
    cat ${target_file};

    cp ${generic_file} ${target_file};

    sed -i "s:---n---:${n}:" ${target_file};
    sed -i "s:---target_file---:${target_file_output}:" ${target_file};

    echo "updated namelist:";
    cat ${target_file};

    # we send the job (running bash shell.sh) to the nodes
    # bash shell.sh
    qsub -q all.q -cwd -o qsub${k}.out -e qsub${k}.err ./shell.sh ${k};
    echo "output:";
    cat qsub${k}.out;
    echo "errors:";
    cat qsub${k}.err;

done;

echo "done.";
