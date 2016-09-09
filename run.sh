#!/bin/sh

input_dir=/data

output_dir=/data

surf_dir=$input_dir/001/surf/

temp_dir=/tmp

#run freesurfer

SUBJECTS_DIR=$input_dir

recon-all -subjid 001 -autorecon2 -i /data/*.nii.gz

cp $surf_dir/lh.pial $temp_dir/
cp $surf_dir/lh.pial $temp_dir/

#combine meshes

mris_convert --combinesurfs $temp_dir/lh.pial $temp_dir/rh.pial $temp_dir/brain.pial
mris_convert $temp_dir/brain.pial $temp_dir/brain.stl

#smooth/decimate?
#TODO

#convert to pov

/stl2pov/stl2pov $temp_dir/brain.stl > $temp_dir/brain.pov

#make gif

/brain_printer/pov2gif.sh $temp_dir/brain.pov $temp_dir/brain.gif

#copy outputs to output directory

cp $temp_dir/brain.stl $output_dir
cp $temp_dir/brain.gif $output_dir


