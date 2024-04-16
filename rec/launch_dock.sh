source /home/mathar/programs/mgltools_x86_64Linux2_1.5.7/bin/mglenv.sh
PROTEIN_PATH="../../protein/prepared_protein/bound_V610F_R6G_spacing_0.20"
for ligand_file in ../../ligands/str_pH_5.7/output_conformers/*.mol2 ; do
    # Create a folder for each ligand
    ligand_base=$(basename "$ligand_file" .mol2) 
    mkdir -p $ligand_base
   echo $ligand_base.mol2
  echo $ligand_file 
    # Copy ligand into the folder
    cp $ligand_file $ligand_base/
    cp $PROTEIN_PATH/*.map $ligand_base/
        cp $PROTEIN_PATH/*.pdbqt $ligand_base/
        cp $PROTEIN_PATH/*.xyz $ligand_base/
        cp $PROTEIN_PATH/*.fld $ligand_base/
        cp $PROTEIN_PATH/*.gpf $ligand_base/
    cd  $ligand_base
    python /home/mathar/programs/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l "$ligand_base.mol2" -o "${ligand_base}_prepared.pdbqt" -C
python /home/mathar/programs/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_dpf4.py -l "${ligand_base}_prepared.pdbqt" -r R6G-Bound_V610F_MdtF_clean_prot.pdbqt -o "dock.dpf"
/home/mathar/local/AUTODOCK/autodock4 -p dock.dpf -l dock.dlg
grep Estimated dock.dlg | grep Free > score_summary.dat
awk -v path="$(pwd)/" '{print path $0}' score_summary.dat >> ../ALL_score_summary.dat
grep '^DOCKED' dock.dlg | cut -c9- > "${ligand_base}_poses.pdbqt"
obabel "${ligand_base}_poses.pdbqt" -O dock.pdb
cat ../../../protein/prepared_protein/bound_V610F_R6G_spacing_0.20/R6G-Bound_V610F_MdtF-SMALPs_5_7.pdb dock.pdb > combined_ref_poses.pdb #select right prepared pdb file for the complex (reference holo)
rm *.map *.fld *.gpf *.xyz
vmd -dispdev none -e ../../measure_com.tcl
    cd ..
done
