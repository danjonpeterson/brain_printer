# brain_printer

Do you have an MRI of your Brain? 

Do you want to get an stl file of your brain 
(so that you can make 3D print of it)?

All you need is Docker.


This project describes the creation of a docker image that can take an MRI scan and output an .stl file suitable for 3d printing

It also generates a rotating .gif of that .stl file so that you can see if it's worth printing.


HOW TO USE THIS REPOSITORY

1) install docker

https://www.docker.com/

2) clone this repository

> git clone https://github.com/danjonpeterson/brain_printer.git

2) build the image from the Dockerfile, call it brain_printer

> cd brain_printer
> docker build -t brain_printer .

3) put your brain image (in nifti or nifti_gz format) in an empty directory, say print_my_brain/

> mkdir print_my_brain/
> cp my_brain.nii.gz print_my_brain/

4) run the docker image, mounting your newly created directory in /data

> docker run -ti --rm -v /full/path/to/print_my_brain/:/data brain_printer

5) from the docker image, run the script run.sh

> /brain_printer/run.sh

