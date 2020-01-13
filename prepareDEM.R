library(raster)

# DEM files downloaded from 
# https://opendem.info/OpenDemEU/getData.jsp?xmin=4384542.1862237835&xmax=4497832.47750067&ymin=2609541.8919157316&ymax=2710518.0210973043

dem1 <- raster("C:/Users/janst/Downloads/N260E440/N260E440/N260E440.tif")
dem2 <- raster("C:/Users/janst/Downloads/N265E440/N265E440/N265E440.tif")
dem3 <- raster("C:/Users/janst/Downloads/N260E445/N260E445/N260E445.tif")
dem4 <- raster("C:/Users/janst/Downloads/N265E445/N265E445/N265E445.tif")


layer <- list(dem1, dem2, dem3, dem4)

merged <- do.call(merge, layer)

dem_pr <- projectRaster(merged, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

extent <- raster("C:/Users/janst/Documents/Uni/WS 1920/SP - Remote Sensing Analysis/oafogsathg/data/LC08_L1TP_193027_20190827_20190903_01_T1/classified.tif")

demCropped <- crop(dem_pr, extent, filename="C:/Users/janst/Documents/Uni/WS 1920/SP - Remote Sensing Analysis/oafogsathg/data/DEMmerged.tif")

# writeRaster(merged, "C:/Users/janst/Documents/Uni/WS 1920/SP - Remote Sensing Analysis/oafogsathg/data/DEMmerged.tif", overwrite=TRUE)

# dem <- raster("C:/Users/janst/Documents/Uni/WS 1920/SP - Remote Sensing Analysis/oafogsathg/data/DEMmerged.tif")

spplot(demCropped)


