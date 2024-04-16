# Load the reference structure
mol new R6G.pdbqt type pdb
set ref [atomselect top all]

# Open the output file for writing
set outfile [open "distance_results.txt" w]

# Load the dock.pdb trajectory
mol new dock.pdb type pdb first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all

# Loop over frames
set num_frames [molinfo top get numframes]
for {set i 0} {$i < $num_frames} {incr i} {
    # Set the current frame
    animate goto $i

    # Get the atom selection for the current frame
    set frame [atomselect top "all"]

    # Calculate the center of mass
    set com_ref [measure center $ref]
    set com_frame [measure center $frame]

    # Calculate the vector distance
    set distance [vecdist $com_ref $com_frame]

    # Write the distance to the output file
    puts $outfile "Frame $i: $distance"
}

# Close the output file
close $outfile

# Clean up
$ref delete
quit
