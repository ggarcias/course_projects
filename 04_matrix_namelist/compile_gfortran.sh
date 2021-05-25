#!/bin/bash

gfortran -std=f2003 -Wextra -Wall fortran.f90 -o output_fortran${1}.out; ./output_fortran${1}.out;
