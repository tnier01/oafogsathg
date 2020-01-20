# classification based on: https://github.com/HannaMeyer/Geostat2018/tree/master/practice

########  Loading different libarys  ######## 
library(raster)
library(caret)
# library(mapview)
library(sf)
library(rgdal)

# source(paste(getwd(),"/preparation.R",sep=""))

# customize the name of the landsat data folder e.g. LC08_L1TP_193027_20190827_20190903_01_T1
# data_folder <- ("LC08_L1TP_192027_20160827_20170321_01_T1")

# landsat <- band_stack(data_folder)

# landsat <- stack(paste(getwd(),"/data/",data_folder,"/rstackCropGrid.gri",sep=""))

###############################
###! create training sites !###
###############################


# setting the path were all files were saved 
## use your data folder as setwd, because there the needed file from preparation is saved 
#setwd("...")

######## functions ######## 
#1# function for classifing  
classify <- function(scene, landsat) {
  
  model <- readRDS("dataSurveyArea/model.Rds")
  
  # model prediction 
  ## model is applied on the full raster stack using the predict function from the raster package
  prediction <- predict(landsat,model)
  
  classified <- writeRaster(prediction, filename = paste("data/",scene,"/classifiedNoShadow",sep = ""), format = "GTiff", options=c("COMPRESS=NONE", "TFW=YES"), overwrite = TRUE)
  
  return(classified)
}

area_calculation <- function(scene, landsat) {
  # classification calculation 
  classified <- classify(scene, landsat)

  # crop the classified raster by a shapefile to focus on the Hintertux Glacier 
  HintertuxGlacierExtent <- readOGR("dataSurveyArea/HintertuxGlacierExtent.shp")
  
  classified_crop <- crop(classified, HintertuxGlacierExtent)
  
  spplot(classified_crop,col.regions=c("black","darkgreen","green","gray", "blue","white"), maxpixels=1000000)
  
  # pixels used for different classes 
  classified_crop@data@attributes
  pixels <- freq(classified_crop)
  
  # area in square meters which is signed concerning the class ice and snow (1 pixel -> 30m*30m)
  ice_area <- as.numeric(pixels[3,2] + pixels[5,2])*900
  
  return(ice_area)
}

# HintertuxGlacierArea <- area_calculation(data_folder, landsat)

getAreaFromClassified <- function(scene) {
  classified <- raster(paste("data/",scene,"/classifiedNoShadow.tif",sep=""))
  
  HintertuxGlacierExtent <- readOGR("dataSurveyArea/HintertuxGlacierExtent.shp")
  
  classified_crop <- crop(classified, HintertuxGlacierExtent)
  
  spplot(classified_crop,col.regions=c("black","darkgreen","green","gray", "blue","white"), maxpixels=1000000)
  
  # pixels used for different classes 
  classified_crop@data@attributes
  pixels <- freq(classified_crop)
  
  # area in square meters which is signed concerning the class ice and snow (1 pixel -> 30m*30m)
  ice_area <- as.numeric(pixels[3,2] + pixels[5,2])*900
  
  return(ice_area)
}










