# classification based on: https://github.com/HannaMeyer/Geostat2018/tree/master/practice

########  Loading different libarys  ######## 
library(raster)

######## functions ######## 
#1# function for classifing  
classify <- function(scene, landsat) {
  
  # for the classification a model is used which was calculated on basis of data of 27.08.2019
  # the training of the model was performed by the trainModel.R-script 
  model <- readRDS("dataSurveyArea/model.Rds")
  
  # model prediction 
  ## model is applied on the full raster stack using the predict function from the raster package
  prediction <- predict(landsat,model)
  
  classified <- writeRaster(prediction, filename = paste("data/",scene,"/classifiedNoShadow",sep = ""), format = "GTiff", options=c("COMPRESS=NONE", "TFW=YES"), overwrite = TRUE)
  
  return(classified)
}

#2# function for calculation of the snow and ice area which basis on the pixels of the classification 
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

#3# function 
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










