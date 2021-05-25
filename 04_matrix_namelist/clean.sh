#!/bin/bash

for element in $(find ./ -name "qsub*"); do rm ${element}; done;
for element in $(find ./ -name "output_fortran*"); do rm ${element}; done;
for element in $(find ./ -name "file_matrix*"); do rm ${element}; done;
for element in $(find ./ -name "output*"); do rm -r ${element}; done;
