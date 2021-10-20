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
##dem 
dir.create("./2_data/dem", showWarnings = FALSE)
shape <- vect("./2_data/shapes/boundbuche.shp")
dempath <- "G:/processed"
impath <-"./2_data/bands"
outpath <-"./2_data/dem"
dtm <- "./2_data/dtm_main_gcps.tif"


ls <- list.files(impath, pattern = ".tif", full.names = TRUE, recursive = TRUE)
length(ls)

lsr <- lapply(ls, rast)
lsr

ds <- list.files(dempath, pattern = "dem.tif", full.names = TRUE, recursive = TRUE)
length(ds)
ds
dsr <- lapply(ds, rast)
dsr

source("./3_src/r/functions/clip_dem.R")
cores <- makeCluster(detectCores() - 1)
beginCluster(cores)
clip_dem(orlist = ls,
         imlist = lsr,
         demlist = dsr,
         dtm,
         shape,
         outpath)
endCluster()

#######################################
#vegindices

orpath <- "./2_data/bands"
impath <-"./2_data/dem"
dir.create("./2_data/indices", showWarnings = FALSE)
outpath <-"./2_data/indices"


orlist <- list.files(orpath, pattern = ".tif", full.names = TRUE, recursive = TRUE)
ls <- list.files(impath, pattern = ".tif", full.names = TRUE, recursive = TRUE)
length(ls)
ls
lsr <- lapply(ls, rast)
lsr


source("./3_src/r/functions/indices.R")
cores <- makeCluster(detectCores() - 1)
beginCluster(cores)
indices(orlist = orlist,
         imlist = lsr,
         outpath)
endCluster()













