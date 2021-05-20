#!/bin/bash

# 1) Create a bash script that takes 1 integer as an input and returns "file_<integer>.txt"
# in the folder "folder_<integer>"

echo "running ${pwd}/script_01_folders_files_integer.sh...";

mkdir folder_${1};
echo "the directory folder_${1} was sucessfully created at ${pwd}/folder_${1}";
ls;

touch  folder_${1}/file_${1}
echo "file_${1} was successfully created at ${pwd}/folder_${1}/file_${1}";
ls;

echo "done.";
