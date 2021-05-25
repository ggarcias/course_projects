#!/bin/bash

mkdir output;
for element in $(find ./ -type d -name "output*"); do mv ${element} output; done;
#for element in $(find ./ -name "qsub*"); do mv ${element} output; done;
#for element in $(find ./ -name "output_fortran*"); do mv ${element} output; done;
#for element in $(find ./ -name "file_matrix*"); do mv ${element} output; done;
#for element in $(find ./ -name "output*"); do mv ${element} output/element; done;
