pacman::p_load(raster, rgdal, RStoolbox, parallel, snow, terra, lidR, tools)
library(terra)
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


##
test <- rast("C:/root/projects/phenospringproc/2_data/dem/altum_2020_100_w_chm.tif")
test <- rast("C:/root/projects/phenospringproc/2_data/altum_2020_100_w_chm.tif")
dsr[[1]]
test$chm












 writeRaster(chm, paste0(output, "/", sens, "_", year, "_", doy, ".tif"),
            names = names(re),
            overwrite=TRUE,
            filetype = "FLT8s")
x <- paste0("Processed: ", i, " / ", length(list), "\nFilename: ", "'", output,
            "/", sens, "_", year, "_", doy, ".tif'\n")
writeLines(x)





#Testing
resolution <- 0.1 
refimage <- dsr[[1]]
terra::res(refimage) <- resolution

# cliprefimage
im <- refimage
cr <- terra::crop(im, shape, snap = "out")
exr <- terra::rasterize(shape, cr)
refclip <- terra::mask(cr, exr)
plot(refclip)

# clip dtm
im <- rast(dtm)
cr <- terra::crop(im, shape, snap = "out")
exr <- terra::rasterize(shape, cr)
dtmclip <- terra::mask(cr, exr)
dtmre <- terra::resample(dtmclip, refclip, method = "bilinear")
plot(dtmre)
dtmre

# clip dsm
cr <- terra::crop(dsr[[13]], shape, snap = "out")
exr <- terra::rasterize(shape, cr)
dsmclip <- terra::mask(cr, exr)
dsmre <- terra::resample(dsmclip, refclip, method = "bilinear")
plot(dsmre)
dsmre

chm <- dsmre - dtmre

plot(chm)


