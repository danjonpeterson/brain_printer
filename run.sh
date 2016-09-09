#!/bin/sh

input_dir=/data

output_dir=/data

surf_dir=$input_dir/001/surf

temp_dir=/tmp

echo ==================
echo running freesurfer
echo ==================

SUBJECTS_DIR=$input_dir

recon-all -subjid 001 -all -i $input_dir/*.nii*

cp $surf_dir/lh.pial $temp_dir/
cp $surf_dir/rh.pial $temp_dir/

echo ==================
echo converting meshes
echo ==================

mris_convert $temp_dir/lh.pial $temp_dir/lh.stl
mris_convert $temp_dir/rh.pial $temp_dir/rh.stl


#smooth/decimate?
#TODO

echo ==================
echo converting to pov
echo ==================


/stl2pov/stl2pov $temp_dir/lh.stl > $temp_dir/lh.pov
/stl2pov/stl2pov $temp_dir/rh.stl > $temp_dir/rh.pov

echo ==================
echo    making gif
echo ==================


/brain_printer/pov2gif.sh $temp_dir/lh.pov $temp_dir/lh.gif
/brain_printer/pov2gif.sh $temp_dir/rh.pov $temp_dir/rh.gif

echo ===================================
echo copying outputs to output directory
echo ===================================

cp $temp_dir/lh.stl $output_dir
cp $temp_dir/rh.stl $output_dir

cp $temp_dir/lh.gif $output_dir
cp $temp_dir/rh.gif $output_dir





