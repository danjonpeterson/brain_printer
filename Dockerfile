# Create an image for obtaining an .stl file from an MRI volume using freesurfer

# see https://github.com/danjonpeterson/brain_printer

# start with vistalabs freesurfer image
FROM vistalab/freesurfer

## BEGIN INSTALL AWSCLI
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --upgrade pip \
    && apt-get clean

RUN pip3 --no-cache-dir install --upgrade awscli --ignore-installed
## END INSTALL AWSCLI

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
RUN git clone https://github.com/danjonpeterson/brain_printer/





