######## DEM preperation script ########
# This is an optional script, which is not directly needed for the main process. It was used by the developers 
# to prepare the digital elevation model concerning extent and projection- 


######## Loading different libarys ######## 
library(raster)


######## preperation ######## 
# DEM files downloaded from 
# https://opendem.info/OpenDemEU/getData.jsp?xmin=4384542.1862237835&xmax=4497832.47750067&ymin=2609541.8919157316&ymax=2710518.0210973043

dem1 <- raster("your_directory_to_the_DEM_tile")
dem2 <- raster("your_directory_to_the_DEM_tile")
dem3 <- raster("your_directory_to_the_DEM_tile")
dem4 <- raster("your_directory_to_the_DEM_tile")

layer <- list(dem1, dem2, dem3, dem4)

merged <- do.call(merge, layer)

dem_pr <- projectRaster(merged, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

extent <- raster("your_directory_to_save_the_extent")

demCropped <- crop(dem_pr, extent, filename="your_directory_to_the_extent")

spplot(demCropped)


