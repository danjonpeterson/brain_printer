# script to decimate an .stl mesh
# usage:
# Rscript mesh-decim.r input.stl output.stl face_count

library(Rvcg)
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} 

brainMesh = vcgImport(args[1])
brainMesh_decim  = vcgQEdecim(brainMesh,as.integer(args[3]))
vcgStlWrite(brainMesh_decim,substr(args[2], 1,nchar(args[2])-4))