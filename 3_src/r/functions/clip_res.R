pacman::p_load(raster, rgdal, parallel, snow, terra)

clip_res <- function(list = ls, 
                     input = lsr, 
                     refimage = ref, 
                     output = outpath,
                     resolution = 0.03){
  
  res(refimage) <- resolution

  rast <- NULL
  for(i in 1:length(input)){
    for(j in 1:nlayers(input[[i]])) {
      re <- resample(input[[i]][[j]], refimage, method = "bilinear")
      ex <- extent(shp)
      ma <- raster::mask(re, shp)
      cr <- crop(ma, ex, snap = "out")
      rast[[j]] <- cr
      }
  
  num <- regmatches(ls[i], gregexpr("[[:digit:]]+", ls[i]))
  dstr <- sapply(num, tail, 1)
  date <- format(as.Date(dstr, "%d%m%Y"),  "%Y-%m-%d")
  year <- format(as.Date(date, "%Y-%m-%d"), "%Y")
  doy <- strptime(date, format = "%Y-%m-%d")$yday+1
  if (nlayers(input[[i]]) == 3){
    names(input[[i]]) <- c("blue", "green", "red")
  } else if (nlayers(input[[i]]) == 5){
    names(input[[i]]) <- c("blue", "green", "red", "nir", "rededge")
  } else if (nlayers(input[[i]]) == 6){
    names(input[[i]]) <- c("blue", "green", "red", "nir", "rededge", "tir")
  }
  
  if (nlayers(input[[i]]) == 3){
    sens <- "RGB"
  } else if (nlayers(input[[i]]) == 5){
    sens <- "multi"
  } else if (nlayers(input[[i]]) == 6){
    sens <- "multi"
  }

  writeRaster(rast, paste0(output, "/", sens, "_", year, "_", doy, ".tif"), overwrite=TRUE)
  rast <- NULL
  }
}

rast

