# 0.03 for multispeactral
# 0.01 for RGB

#install.packages("pacman")
pacman::p_load(raster, rgdal, RStoolbox, parallel, snow)

shp <- readOGR("./2_data/shapes/boundbuche.shp")

impath <- "G:/processed/"
outpath <-"./2_data/output"
#dir.create(paste0(outpath, "output"), showWarnings = FALSE)
ls <- list.files(impath, pattern = "orthomosaic.tif", full.names = TRUE, recursive = TRUE)
ls

lsr <- lapply(ls, stack)

source("./3_src/r/functions/clip_res.R")
#lst <- ls[c(1:2)]
#lsrt <- lsr[c(1:2)]

cores <- makeCluster(detectCores() - 1)
beginCluster(cores)


clip_res(list = lst, 
         input = lsrt, 
         refimage = ref, 
         output = outpath,
         resolution = 0.03)

endCluster()


