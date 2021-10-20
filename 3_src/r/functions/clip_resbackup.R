pacman::p_load(raster, rgdal, parallel, snow, terra)

clip_res <- function(list, 
                     input,
                     shape,
                     refimage,
                     dtm,
                     dtmlist,
                     output){
  
  # clip dtm
  resolution <- 0.03
  im <- rast(dtm)
  cr <- terra::crop(im, extent(shape), snap = "out")
  exr <- terra::rasterize(vect(shape), cr)
  dtmclip <- terra::mask(cr, exr)
  
  raster::res(refimage) <- resolution
  refrast <- terra::rast(refimage)
  ref <- terra::crop(refrast, extent(shape), snap = "out")
  
  dtmre <- terra::resample(dtmclip, ref, method = "bilinear")
  
  
  for(i in 1:length(input)){
    im <- rast(input[[i]])
    cr <- terra::crop(im, extent(shape), snap = "out")
    exr <- terra::rasterize(vect(shape), cr)
    ma <- terra::mask(cr, exr)
    
    if (dim(im)[3] == 3){
      resolution <- 0.01
    } else if (dim(im)[3] == 5){
      resolution <- 0.03
    } else if (dim(im)[3] == 6){
      resolution <- 0.03
    }
    raster::res(refimage) <- resolution
    refrast <- terra::rast(refimage)
    ref <- terra::crop(refrast, extent(shape), snap = "out")
    
    re <- terra::resample(ma, ref, method = "bilinear")
    
    num <- regmatches(list[i], gregexpr("[[:digit:]]+", list[i]))
    dstr <- sapply(num, tail, 5)
    date <- format(as.Date(dstr[4], "%d%m%Y"),  "%Y-%m-%d")
    year <- format(as.Date(date, "%Y-%m-%d"), "%Y")
    doy <- strptime(date, format = "%Y-%m-%d")$yday+1
    
    
    
    
    # clip dtm
    im <- rast(dtm)
    cr <- terra::crop(im, extent(shape), snap = "out")
    exr <- terra::rasterize(vect(shape), cr)
    dtmclip <- terra::mask(cr, exr)
    
    raster::res(refimage) <- resolution
    refrast <- terra::rast(refimage)
    ref <- terra::crop(refrast, extent(shape), snap = "out")
    
    dtmre <- terra::resample(dtmclip, ref, method = "bilinear")
    
    # clip dsr
    im <- rast(dsr[[i]])
    cr <- terra::crop(im, extent(shape), snap = "out")
    exr <- terra::rasterize(vect(shape), cr)
    dtmclip <- terra::mask(cr, exr)
    
    #raster::res(refimage) <- resolution
    #refrast <- terra::rast(refimage)
    #ref <- terra::crop(refrast, extent(shape), snap = "out")
    
    dsre <- terra::resample(dtmclip, ref, method = "bilinear")
    
    dem <- dsre - dtmre
    re <- c(re, dem)
    
    if (dim(re)[3] == 3){
      sens <- "RGB"
    } else if (dim(re)[3] == 5){
      sens <- "rededge"
    } else if (dim(re)[3] == 6){
      sens <- "altum"
    }
    
    writeRaster(re, paste0(output, "/", sens, "_", year, "_", doy, ".tif"),
                filename=names(re), bylayer=TRUE,
                overwrite=TRUE)
  }
}
#ndvi <- (bds[[i]][[4]] - bds[[i]][[3]]) / (bds[[i]][[4]] + bds[[i]][[3]])

#gcc <- input[[i]][[2]] / (input[[i]][[2]] + input[[i]][[1]] + input[[i]][[3]])
# sens <- "RGB"

# if (dim(re)[3] == 3){
#   names(re) <- c("blue", "green", "red")
# } else if (dim(re)[3] == 5){
#   names(re) <- c("blue", "green", "red", "nir", "rededge")
# } else if (dim(re)[3] == 6){
#   names(re) <- c("blue", "green", "red", "nir", "rededge", "tir")
# }