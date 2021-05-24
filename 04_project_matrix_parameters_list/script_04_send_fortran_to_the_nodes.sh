#!/bin/bash

# this code must: send project_04_read_namelist_create_and_save_matrix.f90 jobs to the nodes
# it is also in this code that we will modify the namelist

# first let's create a working directory (if it doesn't already exist) to store our future files
mkdir output_04;

# let's keep a track of our original path:
original_path=$(pwd)

# let's do a loop from 1 to 10, the n° of the loop will be the n-size of the matrix & the extension of the target_file

# LOOP FROM 1 TO 10
for k in {1..10};
do
    # we change the values inside the namelist file according to the loop iteration
    n=${k};
    target_file_output="matrix${k}.txt";

    target_file="parameters_matrix_size_and_target_file.list"
    generic_file="parameters_matrix_size_and_target_file.list.generic"

    cp ${generic_file} ${target_file};

    sed -i "s:---n---:${n}:" ${target_file};
    sed -i "s:---target_file---:${target_file_output}:" ${target_file};

    # we send the job to the nodes and stock the result in the new folder
    qsub -q all.q -wd $(pwd)/output_04 -e project_04_read_namelist_create_and_save_matrix.err -o project_04_read_namelist_create_and_save_matrix.out compile_gfortran.sh project_04_read_namelist_create_and_save_matrix.f90;

    cd ${original_path};

done;

