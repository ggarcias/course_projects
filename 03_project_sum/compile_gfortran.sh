#!/bin/bash

# we want to automatize: gfortran -std=f95 -Wextra -Wall sum.f90 -o sumf95WextraWall.out

# parameter n°1 is NameOfFile.FORMAT

root_name=$(echo ${1} | awk -F '.' '{print $1}');

gfortran -std=f2003 -Wextra -Wall ${1} -o ${root_name}.out; ls; ./${root_name}.out
