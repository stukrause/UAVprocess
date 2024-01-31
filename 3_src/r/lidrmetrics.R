devtools::install_github("ptompalski/lidRmetrics")
install.packages("Lmoments")
library(Lmoments)
library(lidR)
library(lidRmetrics)
detach(lidRmetrics)

LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
las <- readLAS(LASfile, select = "*", filter = "-keep_random_fraction 0.5")

m1 <- cloud_metrics(las, ~metrics_basic(Z))

m2 <- grid_metrics(las, ~metrics_set1(Z), res = 10)

m3 <- grid_metrics(las, ~metrics_set2(X, Y, Z), res = 10)
plot(m2$lad_mean)

edit(metrics_voxels)
m4 <- grid_metrics(las, ~metrics_voxels(x = X, y = Y, z = Z), res = 10)

plot(m4$ClosedGapSpace)

metrics_voxels <- function(x, y, z, vox_size=1, zmin = NA) {
  
  vn <- vFRall <- vFRcanopy <- NA_real_
  
  if (length(z) > 2) {
    
    vox <- lidRmetrics:::create_voxels(x = x, y = y, z = z, vox_size = vox_size, zmin = zmin)
    
    vox_filled <- vox[!is.na(vox$n),]
    
    vn <- nrow(vox_filled)
    
    # FR (filling ratio, number of voxels with data to the number of all possible voxels)
    vFRall <- nrow(vox_filled) / nrow(vox) * 100
    
    #FR under canopy (limit the filling ratio calculations with the top of the canopy)
    vox2 <- vox %>%
      dplyr::filter(!is.na(n)) %>%         #remove empty voxels
      dplyr::group_by(X, Y) %>%             #for each X and Y...
      dplyr::summarise(zmax = max(Z), .groups = "keep") %>%   #...find the highest voxel
      dplyr::right_join(vox, by=c("X", "Y")) %>%            #combine with original voxel data
      dplyr::filter(Z <= zmax)              #remove empty voxels above canopy
    
    #vFRcanopy <- nrow(vox2[!is.na(vox2$n),])  / nrow(vox2) * 100
    
    #mhist <- lidRmetrics:::metrics_voxstructure(z = vox_filled$Z, vox_size = vox_size)
    
    mlefsky <- lidRmetrics:::metrics_lefsky(x = vox$X, y = vox$Y, z = vox$Z, n=vox$n)
    
  } else {
    
    #mhist <- lidRmetrics:::metrics_voxstructure(z = NA) #this is temporary fix
    mlefsky <- lidRmetrics:::metrics_lefsky(x = NA, y = NA, z = NA, n=NA) #this is temporary fix
    
  }
  
  
  output = list(vn = vn,
                vFRall = vFRall,
                vFRcanopy = vFRcanopy)
  
  #output <- c(output, mhist, mlefsky)
  output <- c(output, mlefsky)
  
  return(output)
  
  
}
