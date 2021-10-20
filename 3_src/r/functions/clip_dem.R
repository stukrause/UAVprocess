pacman::p_load(raster, rgdal, parallel, snow, terra, tools)


clip_dem <- function(orlist,
                     imlist,
                     demlist,
                     dtm = dtm,
                     shape = shape,
                     outpath = outpath){
  
  terra::res(refimage) <- resolution
  
  # cliprefimage
  # terra::res(lsr[[1]])
  # 
  # im <- resorlist[[1]]
  # cr <- terra::crop(im, shape, snap = "out")
  # exr <- terra::rasterize(shape, cr)
  # refclip <- terra::mask(cr, exr)
  #plot(refclip)
  

  
  for(i in 1:length(imlist)){
    refclip <- imlist[[i]]
    
    # clip dtm
    im <- rast(dtm)
    cr <- terra::crop(im, refclip, snap = "out")
    exr <- terra::rasterize(shape, cr)
    dtmclip <- terra::mask(cr, exr)
    dtmre <- terra::resample(dtmclip, refclip, method = "bilinear")
    
    # clip dsm
    cr <- terra::crop(demlist[[i]], refclip, snap = "out")
    exr <- terra::rasterize(shape, cr)
    dsmclip <- terra::mask(cr, exr)
    dsmre <- terra::resample(dsmclip, refclip, method = "bilinear")
    #plot(dsmre)
    dsmre
    
    chm <- dsmre - dtmre
    print(chm)
    plot(chm)
    
    nm <- names(imlist[[i]])
    newnames <- c(nm, "chm")
    imchm <- c(imlist[[i]], chm)
    names(imchm) <- newnames
    filename <- tools::file_path_sans_ext(basename(orlist))
    
    #print(imchm)
    
    writeRaster(imchm, 
                paste0(outpath, "/", filename[i], "_", "w_chm", ".tif"),
                names = names(imchm),
                overwrite=TRUE,
                datatype = "FLT4S")
    
    x <- paste0("Processed: ", i, " ", outpath, "/", filename[i], "_", "w_chm", ".tif")
    writeLines(x)
    
    #dt <- Sys.time()
    #while((as.numeric(Sys.time()) - as.numeric(dt))<3){} 
  }
}