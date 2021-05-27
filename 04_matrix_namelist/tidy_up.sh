#!/bin/bash

mkdir all_outputs;
#for element in $(find ./ -type d -name "output*"); do mv ${element} output; done;
for element in $(find ./ -name "qsub*"); do mv ${element} all_outputs; done;
for element in $(find ./ -name "output_fortran*"); do mv ${element} all_outputs; done;
for element in $(find ./ -name "file_matrix*"); do mv ${element} all_outputs; done;
#for element in $(find ./ -name "output*"); do mv ${element} output/element; done;
for element in $(find ./ -name "output*"); do rm -r ${element}; done;
