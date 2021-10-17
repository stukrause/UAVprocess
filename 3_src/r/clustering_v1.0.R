#install.packages("pacman")
pacman::p_load(raster, rgda, RStoolbox, cluster, randomForest) 


ls <- list.files("./data/raster/input", full.names = TRUE)
ls
st <- list.files("C:/wd/phenology/Krause/input/2019/britz/rgb/bands", full.names = TRUE)
st
ls
rast_st <- stack(rast_st)
rast_st
rast_img <- brick(ls[10])
rast_img <- brick(ls[7])

raster_matrix <- getValues(rast_img)
raster_matrix <- na.omit(raster_matrix)
raster_matrix

rast_img <- stack(ls[9], ls[13])
rast_img
kmn <- kmeans(raster_matrix, centers = 11, iter.max = 1000, algorithm = "Lloyd")
kmn


#?kmeans

kmeans_raster <- raster(rast_img)
kmeans_raster


i <- which(!is.na(raster_matrix))
kmeans_raster[i] <- kmn$cluster
kmeans_raster

ggR(kmeans_raster, geom_raster = TRUE)

clara_fun <- clara(raster_matrix, k = 6, samples = 1000, metric = "euclidean")
#call:clara(raster_matrix, k = 6, samples = 1000, metric = "euclidean")

clara_raster <- raster(rast_img)

i <- which(!is.na(raster_matrix))
clara_raster[i] <- clara_fun$clustering
clara_raster

ggR(clara_raster, geom_raster = TRUE)
