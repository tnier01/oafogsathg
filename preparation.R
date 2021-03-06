######## preperation script ########
# This is the script for preperation of the data including shadow removement, projection fitting, cropping, calculating NDVI and 
# bringing the bands together to an stack. The function band_stack gets called by the "analysis.R"-script. 


######## Loading different libarys ######## 
library(readr)
library(raster)
library(satellite)


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
dhmAustria <- raster("dataSurveyArea/DEM_geschnitten.tif")
# scene <- "LC08_L1TP_192027_20130904_20170502_01_T1"
# band <- raster(paste("data/",scene,"/",scene,"_B2.tif", sep = ""))
# band <- crop(band, dhmAustria)
# there is a need to resample, because the two datasets have different bounding boxes 
  
subtract_shadow <- function(band, dhmAustria, scene) {
  
  # extracting the sun_azimuth and the sun_elevation form a metadata-file of the landsat data 
  MTL <- read_file(paste("data/",scene,"/",scene,"_MTL.txt",sep = ""))
  azimuth_index <- gregexpr('SUN_AZIMUTH', MTL)
  azimuth <- as.numeric(substr(MTL, unlist(azimuth_index)+14, unlist(azimuth_index)+20))
  elevation_index <-gregexpr('SUN_ELEVATION', MTL)
  elevation <- as.numeric(substr(MTL, unlist(elevation_index)+15, unlist(elevation_index)+21))
  
  # band <- crop(band, dhmAustria)
  # there is a need to resample, because the two datasets have different bounding boxes 
  # hillShadeResampled <- resample(hillShadeReprojected, band)
  # slope is needed for hillshade() and calculate by terrain()
  slope <- terrain(dhmAustria, opt="slope", unit="radians")
  # aspect is needed for hillshade() and calculate by terrain()
  aspect <- terrain(dhmAustria, opt="aspect", unit="radians")
  # calculate hillshade (hillSahde is needed for calcTopoCorr), use the MTL.txt file with the values SUN_AZIMUTH = 141.92991720 and SUN_ELEVATION = 61.77340472
  hillShade <- hillShade(slope, aspect, angle=elevation, direction=azimuth, normalize=FALSE)
  # there is a need to bring both datasets on the same projection 
  # hillShadeReprojected <- projectRaster(hillShade, band)
  # use the resampled and reprojected hillShade to finally calculate the corrected rstack
  bandCorrected <- calcTopoCorr(band, hillShade)
  
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
  if(substr(crs(band2, asText=TRUE), 17, 18) != "33") {
    band2 <- projectRaster(band2, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
    band3 <- projectRaster(band3, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
    band4 <- projectRaster(band4, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
    band5 <- projectRaster(band5, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
    band10 <- projectRaster(band10, crs="+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
  }
  
  # subtracting the shadow and cropping 
  # at the moment the function "subtract_shadow" is here not used because we are not quite sure if 
  # the subtracting of the shadow is useful 
  c_band2 <- (cropping(band2, "utm33"))
  c_band3 <- (cropping(band3, "utm33"))
  c_band4 <- (cropping(band4, "utm33"))
  c_band5 <- (cropping(band5, "utm33"))
  c_band10 <- (cropping(band10, "utm33"))
  
  dhmAustriaResampled <- resample(dhmAustria, c_band2)
  
  c_band2 <- subtract_shadow(c_band2, dhmAustriaResampled, scene)
  c_band3 <- subtract_shadow(c_band3, dhmAustriaResampled, scene)
  c_band4 <- subtract_shadow(c_band4, dhmAustriaResampled, scene)
  c_band5 <- subtract_shadow(c_band5, dhmAustriaResampled, scene)
  c_band10 <- subtract_shadow(c_band10, dhmAustriaResampled, scene)
  
  # calculating the ndvi 
  ndvi <- ((c_band5-c_band4)/(c_band5+c_band4))
  
  # bringing the different bands in one stack together 
  landsat_stack <- stack(c_band2, c_band3, c_band4, c_band5, ndvi, c_band10)
  
  layerNames <- c("band2", "band3", "band4", "band5", "NDVI", "band10")
  
  # write the final .grd file 
  rstackCropGrid <- writeRaster(landsat_stack, filename=paste("data/",scene,"/rstackCropGridNoShadow"
                                                              #,substr(scene,17,21)
                                                              ,sep = ""), format="raster", overwrite=TRUE) # save the corrected satellite image as tif
  #names(rstackCropGrid) <- layerNames
  
  return(rstackCropGrid)
}