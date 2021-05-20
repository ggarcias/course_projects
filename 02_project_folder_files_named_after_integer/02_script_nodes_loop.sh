#!/bin/bash

# 2) Do another bash script that send different jobs of the script 1 to the nodes running a loop from 1 to 10



for i in {1..10}; do bash script_folders_files_integer.sh ${i} ; done
