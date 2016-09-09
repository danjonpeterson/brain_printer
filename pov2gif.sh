#!/bin/sh

input=$1

output=$2

temp_base=/tmp/temp

tempfile=${temp_base}.pov

stepsize=0.05


rm -rf ${temp_base}*.png $tempfile

sed '/end\ of\ mesh/q' $input > $tempfile

echo "
  global_settings { ambient_light rgb<1, 1, 1> }
  camera {
    location <147.366, 147.366, 147.366>
    look_at <0, 0, 0>
    rotate <0,clock*360,0>
  }
  light_source { <99.398, 91.1928, 95.2391> color rgb<1, 1, 1>
    rotate <0,clock*360,0>
  }  " >> $tempfile

for s in `seq -w 0.0 $stepsize 1` ; do echo $s ; povray -I${tempfile} -O${temp_base}_${s}.png +k${s} +W640 +H480 ; done

echo making gif from separate images
convert -delay 30 -loop 0 ${temp_base}_*.png $output









