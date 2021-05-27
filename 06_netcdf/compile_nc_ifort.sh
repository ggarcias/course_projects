#!/bin/bash

module load ROMS/intel
ifort ${1} -o out_${1%.*} -I${NETCDF}/include -L${NETCDF}/lib -lnetcdff
./out_${1%.*}
module unload ROMS/intel
