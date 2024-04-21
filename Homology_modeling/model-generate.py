# Homology modeling by the automodel class 
from modeller import *                   # Load standard Modeller classes 
from modeller.automodel import *         # Load the automodel class

seq="adeB"
align="alignment.ali"
struct="2J8S.pdb"

log.verbose()                            # request verbose output 
env = environ()                          # create a new MODELLER environment to build this model in

env.libs.topology.read(file='$(LIB)/top_heav.lib')  # H are not taken into calculations
env.libs.parameters.read(file='$(LIB)/par.lib')

# directories for input atom files 
env.io.atom_files_directory = ['.', '../atom_files']

a = automodel(env, 
              # file with template codes and target sequence
              alnfile=align, 
              # PDB codes of the templates
              knowns=struct,
              # code of the target
              sequence=seq,
              # print dope score for models
              assess_methods=(assess.DOPE))

a.starting_model = 1
a.ending_model = 25
#a.auto_align() # get an automatic alignment
a.make()       # do homolgy modeling
