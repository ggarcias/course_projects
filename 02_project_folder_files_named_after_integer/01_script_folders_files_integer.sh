#!/bin/bash

# 1) Create a bash script that takes 1 integer as an input and returns "file_<integer>.txt"
# in the folder "folder_<integer>"

mkdir folder_${1}; touch  folder_${1}/file_${1};



