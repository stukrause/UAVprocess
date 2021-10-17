pacman::p_load(raster, rgdal, parallel, snow)

indices <- function(list = ls, 
                     input = lsr, 
                     refimage = ref, 
                     output = outpath,
                     resolution){
  
  
  

  