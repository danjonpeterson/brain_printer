#!/bin/bash
set -e

#---------variables and defaults---------#
user=user-$(date +%Y-%m-%d_%H:%M:%S)
testing="FALSE"
mode="S3"

#------------- parsing parameters ----------------#

while getopts u:tl OPT
 do
 case "$OPT" in
   "u" ) user="$OPTARG";;
   "t" ) testing="TRUE";;
   "l" ) mode="LOCAL";;
    * )  usage_exit;;
 esac
done;

echo user: $user
echo testing: $testing

input_dir=/data

output_dir=/output

surf_dir=$input_dir/001/surf

temp_dir=/tmp

if [ "$mode" = "S3" ]; then

	echo ==================
	echo     setup AWS
	echo ==================

	mkdir -p /data

#	if [ "$AWS_ACCESS_KEY_ID" = "" ] || [ "$AWS_SECRET_ACCESS_KEY" = "" ]; then
#		echo ERROR: missing AWS credentials
#		exit 1
#	fi

	aws configure set region us-west-2

	if [ "$testing" = "FALSE" ]; then

		echo ======================
		echo  reading data from s3
		echo ======================

		aws s3 cp s3://print-my-brain/input/user-${user}.nii.gz /data/user-${user}.nii.gz

	fi
fi

if [ "$testing" = "FALSE" ]; then

	echo ==================
	echo running freesurfer
	echo ==================
	
	export SUBJECTS_DIR=$input_dir
	
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
	
	cp $temp_dir/lh.stl $output_dir/user-${user}-lh.stl
	cp $temp_dir/rh.stl $output_dir/user-${user}-rh.stl
	
	cp $temp_dir/lh.gif $output_dir/user-${user}-lh.gif
	cp $temp_dir/rh.gif $output_dir/user-${user}-rh.gif
fi


if [ "$mode" = "S3" ]; then

	echo ===================================
	echo       copying outputs to S3
	echo ===================================

	if [ "$testing" = "TRUE" ]; then

		aws s3 cp s3://print-my-brain/output/user-djp-lh.gif $temp_dir/user-${user}-lh.gif
		aws s3 cp s3://print-my-brain/output/user-djp-lh.stl $temp_dir/user-${user}-lh.stl
		aws s3 cp s3://print-my-brain/output/user-djp-rh.gif $temp_dir/user-${user}-rh.gif
		aws s3 cp s3://print-my-brain/output/user-djp-rh.stl $temp_dir/user-${user}-rh.stl

		aws s3 cp $temp_dir/user-${user}-lh.gif s3://print-my-brain/output/user-${user}-lh.gif
		aws s3 cp $temp_dir/user-${user}-lh.stl s3://print-my-brain/output/user-${user}-lh.stl
		aws s3 cp $temp_dir/user-${user}-rh.gif s3://print-my-brain/output/user-${user}-rh.gif
		aws s3 cp $temp_dir/user-${user}-rh.stl s3://print-my-brain/output/user-${user}-rh.stl

	elif [ "$testing" = "FALSE" ]; then
		aws s3 cp $output_dir/user-${user}-lh.gif s3://print-my-brain/output/user-${user}-lh.gif
		aws s3 cp $output_dir/user-${user}-lh.stl s3://print-my-brain/output/user-${user}-lh.stl
		aws s3 cp $output_dir/user-${user}-rh.gif s3://print-my-brain/output/user-${user}-rh.gif
		aws s3 cp $output_dir/user-${user}-rh.stl s3://print-my-brain/output/user-${user}-rh.stl
	else
		echo ERROR: variable testing: $testing neither TRUE nor FALSE
		exit 1
	fi

fi




