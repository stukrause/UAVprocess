# 0.03 for multispeactral
# 0.01 for RGB

#install.packages("pacman")
pacman::p_load(raster, rgdal, RStoolbox, parallel, snow, terra, tools)

#library(raster)
#remove.packages("terra")
#install.packages("terra")
#library(terra)
shp <- readOGR("./2_data/shapes/boundbuche.shp")

impath <- "G:/processed"
impath
dir.create("./2_data/bands", showWarnings = FALSE)
outpath <-"./2_data/bands"

ls <- list.files(impath, pattern = "orthomosaic.tif", full.names = TRUE, recursive = TRUE)
length(ls)
ls
lsr <- lapply(ls, stack)
lsr

#lst <- ls[c(1:5)]
#lsrt <- lsr[c(1:5)]
reference <- lsr[[1]]

source("./3_src/r/functions/clip_res.R")
cores <- makeCluster(detectCores() - 1)
beginCluster(cores)

clip_res(list = ls, 
         input = lsr, 
         shape = shp,
         refimage = reference,
         output = outpath)
endCluster()

########################################








