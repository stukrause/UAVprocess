pacman::p_load(raster, rgdal, parallel, snow, terra, tools)

clip_res <- function(list, 
                     input,
                     shape,
                     refimage,
                     output){

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
  
      #num <- regmatches(list[i], gregexpr("[[:digit:]]+", list[i]))
      num <- regmatches(list[i], gregexpr("\\d{8}", list[i]))
      dstr <- sapply(num, tail, 1)
      date <- format(as.Date(dstr, "%d%m%Y"),  "%Y-%m-%d")
      year <- format(as.Date(date, "%Y-%m-%d"), "%Y")
      doy <- strptime(date, format = "%Y-%m-%d")$yday+1
  
      if (dim(re)[3] == 3){
        sens <- "RGB"
      } else if (dim(re)[3] == 5){
        sens <- "rededge"
      } else if (dim(re)[3] == 6){
        sens <- "altum"
      }
      
      if (dim(re)[3] == 3){
        names(re) <- c("blue", "green", "red")
      } else if (dim(re)[3] == 5){
        names(re) <- c("blue", "green", "red", "nir", "rededge")
      } else if (dim(re)[3] == 6){
        names(re) <- c("blue", "green", "red", "nir", "rededge", "tir")
      }
      
      bsn <- tools::file_path_sans_ext(basename(list[i]))
      bsn
      id <- substr(bsn, 1, 4)
    
      writeRaster(re, paste0(output, "/", id, "_", sens, "_", year, "_", doy, ".tif"),
                  names = names(re),
                  overwrite=TRUE)
      x <- paste0("Processed: ", i, " / ", length(list), "\nFilename: ", "'", output,
                  "/", id, "_", sens, "_", year, "_", doy, ".tif'\n")
      writeLines(x)
  }
}
