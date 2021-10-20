pacman::p_load(raster, rgdal, parallel, snow, terra, tools)

G <- 2.5
C1 <- 6
C2 <- 7.5
L <- 1


indices <- function(orlist,
                     imlist,
                     outpath = outpath){
  
  
      for(i in 1:length(imlist)){
      
      
      bsn <- tools::file_path_sans_ext(basename(orlist[[i]]))
      
        if (grepl("RGB", bsn) == TRUE){
          
          ##################
          # visible
          gcc <- imlist[[i]]$green / (imlist[[i]]$green + imlist[[i]]$blue + imlist[[i]]$red)
          
          # Tucker 1979
          ngrdi <- (imlist[[i]]$green - imlist[[i]]$red) / (imlist[[i]]$green + imlist[[i]]$red)
          
          nm <- names(imlist[[i]])
          newnames <- c(nm, "gcc", "ngrdi")
          imind <- c(imlist[[i]], gcc, ngrdi)
          names(imind) <- newnames
          filename <- tools::file_path_sans_ext(basename(orlist))
          
          writeRaster(imind, 
                      paste0(outpath, "/", filename[i], "_", "w_indices", ".tif"),
                      names = names(imind),
                      overwrite = TRUE,
                      datatype = "FLT4S")
          
          x <- paste0("Processed: ", i, " ", outpath, "/", filename[i], "_", "w_indices", ".tif")
          writeLines(x)
          
          
        } else if (grepl("rededge", bsn) == TRUE){
          
          ##################
          # visible
          gcc <- imlist[[i]]$green / (imlist[[i]]$green + imlist[[i]]$blue + imlist[[i]]$red)
          
          # Tucker 1979
          ngrdi <- (imlist[[i]]$green - imlist[[i]]$red) / (imlist[[i]]$green + imlist[[i]]$red)
          
          ##################
          # multispectral
          
          ndvi <- (imlist[[i]]$nir - imlist[[i]]$red) / (imlist[[i]]$nir + imlist[[i]]$red)
          
          ndre <- (imlist[[i]]$rededge - imlist[[i]]$red) / (imlist[[i]]$rededge + imlist[[i]]$red)
          
          #Gitelson, A., and M. Merzlyak
          ndrei <- (imlist[[i]]$nir - imlist[[i]]$rededge) / (imlist[[i]]$nir + imlist[[i]]$rededge)
          
          # Gitelson, A., and M. Merzlyak. "Remote Sensing of Chlorophyll Concentration in Higher Plant Leaves." Advances in Space Research 22 (1998): 
          gndvi <- (imlist[[i]]$nir - imlist[[i]]$green) / (imlist[[i]]$nir + imlist[[i]]$green)
          
          evi <- G*((imlist[[i]]$nir - imlist[[i]]$red) / (imlist[[i]]$nir + C1 * imlist[[i]]$red) - C2 * imlist[[i]]$blue + L)
          
          # McFeeters 1996
          ndwi <- (imlist[[i]]$green - imlist[[i]]$nir) / (imlist[[i]]$green + imlist[[i]]$nir)
          
          nm <- names(imlist[[i]])
          newnames <- c(nm, "gcc", "ngrdi", "ndvi", "ndre", "ndrei", "gndvi", "evi", "ndwi")
          imind <- c(imlist[[i]], gcc, ngrdi, ndvi, ndre, ndrei, gndvi, evi, ndwi)
          names(imind) <- newnames
          filename <- tools::file_path_sans_ext(basename(orlist))
          
          writeRaster(imind, 
                      paste0(outpath, "/", filename[i], "_", "w_indices", ".tif"),
                      names = names(imind),
                      overwrite = TRUE,
                      datatype = "FLT4S")
          
          x <- paste0("Processed: ", i, " ", outpath, "/", filename[i], "_", "w_indices", ".tif")
          writeLines(x)
          
          
        } else if (grepl("altum", bsn) == TRUE){
          
          ##################
          # visible
          gcc <- imlist[[i]]$green / (imlist[[i]]$green + imlist[[i]]$blue + imlist[[i]]$red)
          
          gli <- (2 * imlist[[i]]$red - imlist[[i]]$green - imlist[[i]]$blue)
          
          # Tucker 1979
          ngrdi <- (imlist[[i]]$green - imlist[[i]]$red) / (imlist[[i]]$green + imlist[[i]]$red)
          
          ##################
          # multispectral
          
          ndvi <- (imlist[[i]]$nir - imlist[[i]]$red) / (imlist[[i]]$nir + imlist[[i]]$red)
          
          ndre <- (imlist[[i]]$rededge - imlist[[i]]$red) / (imlist[[i]]$rededge + imlist[[i]]$red)
          
          #Gitelson, A., and M. Merzlyak
          ndrei <- (imlist[[i]]$nir - imlist[[i]]$rededge) / (imlist[[i]]$nir + imlist[[i]]$rededge)
          
          # Gitelson, A., and M. Merzlyak. "Remote Sensing of Chlorophyll Concentration in Higher Plant Leaves." Advances in Space Research 22 (1998): 
          gndvi <- (imlist[[i]]$nir - imlist[[i]]$green) / (imlist[[i]]$nir + imlist[[i]]$green)
          
          evi <- G*((imlist[[i]]$nir - imlist[[i]]$red) / (imlist[[i]]$nir + C1 * imlist[[i]]$red) - C2 * imlist[[i]]$blue + L)
          
          # McFeeters 1996
          ndwi <- (imlist[[i]]$green - imlist[[i]]$nir) / (imlist[[i]]$green + imlist[[i]]$nir)
          
          nm <- names(imlist[[i]])
          newnames <- c(nm, "gcc", "ngrdi", "ndvi", "ndre", "ndrei", "gndvi", "evi", "ndwi")
          imind <- c(imlist[[i]], gcc, ngrdi, ndvi, ndre, ndrei, gndvi, evi, ndwi)
          names(imind) <- newnames
          filename <- tools::file_path_sans_ext(basename(orlist))
          
          writeRaster(imind, 
                      paste0(outpath, "/", filename[i], "_", "w_indices", ".tif"),
                      names = names(imind),
                      overwrite = TRUE,
                      datatype = "FLT4S")
          
          x <- paste0("Processed: ", i, " ", outpath, "/", filename[i], "_", "w_indices", ".tif")
          writeLines(x)
        }
        }
}


