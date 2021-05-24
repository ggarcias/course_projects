#!/bin/bash

# sed -i "s:---x---:${variable_to_be_replaced}:" ${target_file}


x="3.0"
y="4.0"

target_file="./my_parameters.list"
generic_file="./my_parameters.list.generic"

cp ${generic_file} ${target_file}

sed -i "s:---x---:${x}:" ${target_file}
sed -i "s:---y---:${y}:" ${target_file}

