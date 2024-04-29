#!/bin/bash

# Activate conda environment
conda activate autodock_gpu

# Set up MGLTools environment
source /home/mathar/programs/mgltools_x86_64Linux2_1.5.7/bin/mglenv.sh
dir=/home/mathar/programs/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24

# Determine box dimensions based on the binding sites residue, selection has to be done inside .tcl script
vmd -dispdev none rec/rec.pdb -e bs_dim_center.tcl
boxscale=1
pts=$(head -n 1 bs_dimension.dat | awk 'BEGIN{FS=",";OFS=","}{printf "%d,%d,%d\n", $1*'${boxscale}',$2*'${boxscale}',$3*'${boxscale}'}')
cnt=$(tail -n 1 bs_dimension.dat)

# Prepare receptor
cd rec
python $dir/prepare_receptor4.py -r rec.pdb -o rec.pdbqt -U nphs -A checkhydrogens

# Prepare grid parameter file
$dir/prepare_gpf4.py -r rec.pdbqt -p npts="${pts}" -p gridcenter="${cnt}" -p spacing=0.25 -p ligand_types="A C NA OA N SA HD F" -o grid.gpf

# Run autogrid
# /home/mathar/local/AUTODOCK/autogrid4 -p grid.gpf -l grid.glg

# Navigate to ligands directory
cd ../ligands

# Loop through ligand files in the ligands directory
for ligand_file in *.pdbqt; do
    # Create directory for each ligand file
    ligand_dir="${ligand_file%.*}"
    mkdir -p $ligand_dir
    cd $ligand_dir
    # Prepare docking parameter file
    python $dir/prepare_dpf4.py -l ../../ligands/$ligand_file -r ../../rec/rec.pdbqt -o dock.dpf
    # Run autodock_gpu_8wi
    autodock_gpu_8wi -ffile ../../rec/rec.maps.fld -lfile ../../ligands/$ligand_file -nrun 10
    cd ..
done
