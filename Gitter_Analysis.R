library(gitter)
setwd("C:/Users/am4613/Desktop/150618_SGA/")

files <- list.files(recursive = T)
files <- files[grepl("jpg", files)]

dir.create("Analysed_Images")
gitter.batch(files, plate.format = c(16, 24), inverse = T, dat.save="Analysed_Images", grid.save="Analysed_Images")
