# 0.03 for multispeactral
# 0.01 for RGB

#install.packages("pacman")
pacman::p_load(raster, rgdal, RStoolbox, parallel, snow, terra)

#library(raster)
#remove.packages("terra")
#install.packages("terra")
#library(terra)
shp <- readOGR("./2_data/shapes/boundbuche.shp")

impath <- "G:/processed"
impath
outpath <-"./2_data/output"
#dir.create(paste0(outpath, "output"), showWarnings = FALSE)
ls <- list.files(impath, pattern = "orthomosaic.tif", full.names = TRUE, recursive = TRUE)
length(ls)
ls
lsr <- lapply(ls, stack)
lsr
ds <- list.files(impath, pattern = "dem.tif", full.names = TRUE, recursive = TRUE)
length(ds)
dsr <- lapply(ds, raster)
dsr
#lst <- ls[c(1:5)]
#lsrt <- lsr[c(1:5)]
reference <- lsr[[1]]


#####################################################
#choose a good Digital Terrain Model for CHM Calculation
dtm <- "C:/root/projects/phenospringproc/2_data/dtm_main_gcps.tif"



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








