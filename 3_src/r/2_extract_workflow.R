pacman::p_load(raster, rgdal, RStoolbox, parallel, snow, terra, tools)

shp <- readOGR("./2_data/shapes/boundbuche.shp")

impath <- "./2_data/indices"
dir.create("./2_data/csv", showWarnings = FALSE)
outpath <-"./2_data/csv"

ls <- list.files(impath, pattern = ".tif", full.names = TRUE, recursive = TRUE)
length(ls)

lsr <- lapply(ls, rast)
lsr

rgb2019 <- list.files(impath, pattern = "RGB_2019", full.names = TRUE, recursive = TRUE)
rgb2019
rededge2019 <- list.files(impath, pattern = "rededge_2019", full.names = TRUE, recursive = TRUE)
rededge2019
rgb2020 <- list.files(impath, pattern = "RGB_2020", full.names = TRUE, recursive = TRUE)
rgb2020
altum2020 <- list.files(impath, pattern = "altum_2020", full.names = TRUE, recursive = TRUE)
altum2020
rgb2021 <- list.files(impath, pattern = "RGB_2021", full.names = TRUE, recursive = TRUE)
rgb2021
altum2021 <- list.files(impath, pattern = "altum_2021", full.names = TRUE, recursive = TRUE)
altum2021

lsls <- mget( c("rgb2019", "rededge2019", "rgb2020", "altum2020", "rgb2021", "altum2021"))
lsls  
  
source("./3_src/r/functions/indices.R")
cores <- makeCluster(detectCores() - 1)
beginCluster(cores)
extract_pixels(imlist,
               outpath)
endCluster()