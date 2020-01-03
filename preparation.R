########  Loading different libarys  ######## 
library(readr)

# setting the path were all files were saved 
setwd("...")

######## functions ######## 
#1# function for cropping an image with a given extent 
cropping <- function(image, coordinateSystem) {
  
  if (coordinateSystem == "utm32") {
    extent <- as(extent(680000, 720000, 5190000, 5240000), 'SpatialPolygons')
  } else if (coordinateSystem =="utm33") {
    extent <- as(extent(230000, 260000, 5200000, 5230000), 'SpatialPolygons')
  } else {
    return("input Coordinate System is unknown!")
  }
  
  crs(extent) <- crs(image)
  imageCrop <- crop(image, extent)
  
  return(imageCrop)
}

#2# calculating data without shadow
# the following calculation are all needed to calculate finally the function "calcTopoCorr", which corrects the satellite image if there are shadows on satellite images 
# sources:
# - terrain function (https://www.rdocumentation.org/packages/raster/versions/3.0-7/topics/terrain)
# - hillShade function (https://www.rdocumentation.org/packages/raster/versions/3.0-7/topics/hillShade)
# - calcTopoCorr function (https://www.rdocumentation.org/packages/satellite/versions/1.0.1/topics/calcTopoCorr)
# - general paper source (https://cran.r-project.org/web/packages/satellite/satellite.pdf)

# preperation of the elevation model 
dhmAustria <- raster("data/DEM_geschnitten.tif")
extent2 <- as(extent(11, 12, 46.5, 47.5), 'SpatialPolygons')
crs(extent2) <- crs(dhmAustria)
dhmAustriaCrop <- crop(dhmAustria, extent2)

subtract_shadow <- function(band, dhmCropped, scene) {
  
  # extracting the sun_azimuth and the sun_elevation form a metadata-file of the landsat data 
  MTL <- read_file(paste("data/",scene,"/",scene,"_MTL.txt",sep = ""))
  azimuth_index <- gregexpr('SUN_AZIMUTH', MTL)
  azimuth <- as.numeric(substr(MTL, unlist(azimuth_index)+14, unlist(azimuth_index)+20))
  elevation_index <-gregexpr('SUN_ELEVATION', MTL)
  elevation <- as.numeric(substr(MTL, unlist(azimuth_index)+15, unlist(azimuth_index)+21))
  
  # slope is needed for hillshade() and calculate by terrain()
  slope <- terrain(dhmCropped, opt="slope", unit="tangent", neighbors=8)
  # aspect is needed for hillshade() and calculate by terrain()
  aspect <- terrain(dhmCropped, opt="aspect", unit="degrees", neighbors=8)
  # calculate hillshade (hillSahde is needed for calcTopoCorr), use the MTL.txt file with the values SUN_AZIMUTH = 141.92991720 and SUN_ELEVATION = 61.77340472
  hillShade <- hillShade(slope, aspect, angle=elevation, direction=azimuth, normalize=FALSE)
  # there is a need to bring both datasets on the same projection 
  hillShadeReprojected <- projectRaster(hillShade, band)
  # there is a need to resample, because the two datasets have different bounding boxes 
  hillShadeResampled <- resample(hillShadeReprojected, band)
  # use the resampled and reprojected hillShade to finally calculate the corrected rstack
  bandCorrected <- calcTopoCorr(band, hillShadeResampled)
  
  return(bandCorrected)
}

#3# final preperation function
band_stack <- function(scene) {
  
  # extraction the three visible (band2 blue, band3 green, band4 red), the infrared (band5) and the thermal channel (band10) 
  band2 <- raster(paste("data/",scene,"/",scene,"_B2.tif", sep = ""))
  band3 <- raster(paste("data/",scene,"/",scene,"_B3.tif", sep = ""))
  band4 <- raster(paste("data/",scene,"/",scene,"_B4.tif", sep = ""))
  band5 <- raster(paste("data/",scene,"/",scene,"_B5.tif", sep = ""))
  band10 <- raster(paste("data/",scene,"/",scene,"_B10.tif", sep = ""))
  
  # bringing the channels on the same projection 
  crs(band2) <- "+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  crs(band3) <- "+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  crs(band4) <- "+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  crs(band5) <- "+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  crs(band10) <- "+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  
  # subtracting the shadow and cropping 
  # at the moment the function "subtract_shadow" is here not used because we are not quite sure if 
  # the subtracting of the shadow is useful 
  c_band2 <- (cropping(band2, "utm33"))
  c_band3 <- (cropping(band3, "utm33"))
  c_band4 <- (cropping(band4, "utm33"))
  c_band5 <- (cropping(band5, "utm33"))
  c_band10 <- (cropping(band10, "utm33"))
  
  # calculating the ndvi 
  ndvi <- ((c_band5-c_band4)/(c_band5+c_band4))
  
  # bringing the different bands in one stack together 
  landsat_stack <- stack(c_band2, c_band3, c_band4, c_band5, ndvi, c_band10)
  
  # write the final .grd file 
  rstackCropGrid <- writeRaster(landsat_stack, filename=paste("data/",scene,"/rstackCropGrid"
                                                              #,substr(scene,17,21)
                                                              ,sep = ""), format="raster", overwrite=TRUE) # save the corrected satellite image as tif
  
  return(rstackCropGrid)
}

# final result: 
grid <- band_stack("LC08_L1TP_192027_20130904_20170502_01_T1")

spplot(grid)