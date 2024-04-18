#!/bin/bash

# Select the number of the GPU(s)
export CUDA_VISIBLE_DEVICES="XX"
# Select type of code (MPI/cuda)
#amber = mpirun -np #PROCS pmemd.MPI
amber=pmemd.cuda

# Relaxation steps
pmemd -O -i relax1.in -o relax1.out -p system.parm7 -c system.rst7 -ref system.rst7 -r relax1.rst7 
pmemd -O -i relax2.in -o relax2.out -p system.parm7 -c relax1.rst7 -ref relax1.rst7 -r relax2.rst7 
pmemd -O -i relax3.in -o relax3.out -p system.parm7 -c relax2.rst7 -ref relax2.rst7 -r relax3.rst7
pmemd -O -i relax4.in -o relax4.out -p system.parm7 -c relax3.rst7 -ref relax3.rst7 -r relax4.rst7
# Heating and equilibration steps
pmemd -O -i heat.in -o heat.out -p system.parm7 -c relax3.rst7 -ref relax3.rst7 -r heat.rst7 -x heat.nc 
pmemd -O -i equil1.in -o equil1.out -p system.parm7 -c heat.rst7 -ref heat.rst7 -r equil1.rst7 -x equil1.nc
pmemd -O -i equil2.in -o equil2.out -p system.parm7 -c equil1.rst7 -ref equil1.rst7 -r equil2.rst7 -x equil2.nc
pmemd -O -i equil3.in -o equil3.out -p system.parm7 -c equil2.rst7 -ref equil2.rst7 -r equil3.rst7 -x equil3.nc
# Production run
$amber -O -i md.in -o md.out -p system.parm7 -c equil3.rst7 -r md.rst7 -x md.nc
