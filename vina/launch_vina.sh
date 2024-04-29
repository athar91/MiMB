#Vina1.2.5 was obtained from conda (https://anaconda.org/conda-forge/vina)
#conda activate vina
source /$path/mgltools_x86_64Linux2_1.5.7/bin/mglenv.sh
MGL_dir=/$path/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24
N_replicas=1
for i in $(ls rec/rec*.pdb) 
do 
filerec=$(basename ${i}) 
dir=$(echo $filerec | awk 'BEGIN{FS="."}{print $1}') 
mkdir -p $dir ; cd $dir 
ln -sf ../rec/$filerec rec.pdb 
python $MGL_dir/prepare_receptor4.py -r rec.pdb -o rec.pdbqt 
#rm rec.pdb
for j in $(ls ../lig/*.pdb) 
do 
filelig=$(basename ${j}) 
lig=$(echo $filelig | awk 'BEGIN{FS="."}{print $1}') 
mkdir $lig ; cd $lig 
ln -s ../../lig/$filelig lig.pdb 
python $MGL_dir/prepare_ligand4.py -Z -l lig.pdb -o lig.pdbqt 
#rm lig.pdb
for k in $(seq 1 1 $N_replicas) 
do 
mkdir $k || exit
cd $k || exit
ln -s ../lig.pdbqt .
ln -s ../../rec.pdbqt .
ln -s ../../../config.txt .
vina --config config.txt 
#rm lig.pdbqt rec.pdbqt config.txt 
#grep -v -e BRANCH -e ROOT -e TORS docked.pdbqt > docked.pdb 
cd ..
done
cd ..
done
cd ..
done
