# Create an image for obtaining an .stl file from an MRI volume using freesurfer

# see https://github.com/danjonpeterson/brain_printer

# start with vistalabs freesurfer image
FROM vistalab/freesurfer


## BEGIN INSTALL POVRAY
RUN apt-get update

RUN apt-get install -y git \ 
                       build-essential \ 
                       libboost-dev \ 
                       libpng12-dev \ 
                       libjpeg8-dev \ 
                       libtiff5-dev \ 
                       autoconf \  
                       libboost-all-dev  

RUN git clone https://github.com/POV-Ray/povray.git
WORKDIR /povray/unix
RUN ./prebuild.sh
WORKDIR /povray
RUN ./configure COMPILED_BY="DJP"
RUN make
RUN make install
## END INSTALL POVRAY

## BEGIN INSTALL STL2POV
WORKDIR /
RUN git clone https://github.com/timschmidt/stl2pov.git
WORKDIR /stl2pov
RUN make
## END INSTALL STL2POV

# install imagemagick
RUN apt-get install -y imagemagick

# git my repo
WORKDIR /
RUN git clone https://github.com/danjonpeterson/brain_printer





