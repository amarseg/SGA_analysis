library(gitter)

files <- list.files(path = "data/Amalia/150618_SGA/", recursive = T, full.names = T)
files <- files[grepl("jpg", files)]

dir.create("Analysed_Images")
gitter.batch(files, plate.format = c(16, 24), inverse = T, dat.save="Analysed_Images", grid.save="Analysed_Images")

files <- list.files(path = "data/Amalia/180718_SGA/", recursive = T, full.names = T)
files <- files[grepl("jpg", files)]

dir.create("data/Amalia/180718_SGA/Analysed_Images")
gitter.batch(files, plate.format = c(16, 24), inverse = T, dat.save="data/Amalia/180718_SGA/Analysed_Images", grid.save="data/Amalia/180718_SGA/Analysed_Images")
