# set cutoff (here 3.5) 
set cutoff 3.5 
set numFrames [molinfo top get numframes] 
#set number of residue for ligands 
set lignd [atomselect top "resname MOL"] 
set l_resid [lsort -integer -uniq [$lignd get resid]] 
set l_residue [lsort -integer -uniq [$lignd get residue]] 
set l_resname [lsort -uniq [$lignd get resname]] 
set n_ligs [llength $l_residue] 
#set protein/nucleic chains 
set pchains [lsort -uniq [[atomselect top protein] get chain]] 
############# 
set out [open "tracking.txt" w] 
    foreach ch $pchains { 
puts $out "###### $l_resname $ch ######" 
puts $out "#frame resids" 
for {set i 1} {$i <= $numFrames} {incr i} { 
    set reg [atomselect top "protein and chain $ch and same residue as within $cutoff of residue $l_residue"] 
    set res_reg [lsort -uniq -integer [[atomselect top [$reg text] frame $i] get resid]] 
    $reg delete 
    if {$res_reg != ""} { 
puts $out "$res_reg" 
    } 
        if {$res_reg == ""} { 
        puts $out "" 
        } 
    unset res_reg 
} 
flush $out 
    } 
close $out 
############ 
quit 
