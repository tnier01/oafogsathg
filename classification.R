# classification based on: https://github.com/HannaMeyer/Geostat2018/tree/master/practice

########  Loading different libarys  ######## 
library(raster)
library(caret)
library(mapview)
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
  
  # loading the data 
  ## landsat data prepared in preparation.R
  landsat <- landsat 
  ## shapefile of the training site prepared in QGIS
  training <- read_sf(paste("data/",scene,"/training_sites.shp",sep = "")) 
  
  # viewRGB(landsat, r = 3, g = 2, b = 1, map.types = "Esri.WorldImagery", maxpixels = 100000)+mapview(training)
  
  # extract raster information 
  ## dataframe which contains the landsat data for each pixel overlayed by the polygons of the training site 
  extr <- extract(landsat, training, df=TRUE)
  ## dataframe merged with the information on the land cover class from the shapefile (training)
  extr <- merge(extr, training, by.x="ID", by.y="id")
  
  # split data 
  ## we split the data in 70% test data and 30% training data 
  ## by the function "createDataPartition" the class distribution is the same in both datasets
  set.seed(100)
  trainids <- createDataPartition(extr$class,list=FALSE,p=0.3)
  trainDat <- extr[trainids,]
  testDat <- extr[-trainids,]
  
  # Visualization of relationships
  #boxplot(trainDat$LC08_L1TP_192027_20130904_20170502_01_T1_B10~trainDat$class,las=2)

  #featurePlot(x = trainDat[, c(paste(scene,"_B2",sep=""),paste(scene,"_B3",sep=""),paste(scene,"_B4",sep=""),paste(scene,"_B5",sep=""),paste(scene,"_B10",sep=""),"layer")], 
  #            y = factor(trainDat$class), 
  #            plot = "pairs",
  #            auto.key = list(columns = 4))
  
  # Model training 
  ## define predictors (all data from the landsat data - layer is here the NDVI)
  ## response variable is the "Class" column of the data frame
  
  
  # predictors with shadow
  # predictors <- c(paste(scene,"_B2",sep=""),paste(scene,"_B3",sep=""),paste(scene,"_B4",sep=""),paste(scene,"_B5",sep=""),paste(scene,"_B10",sep=""),"layer")
  
  # predictors without shadow
  predictors <- c("layer.1", "layer.2", "layer.3", "layer.4", "layer.5", "layer.6")
  
  response <- "class"
  
  # train the model 
  ## we have to decide which methode we want to use, there are a lot of different possibilities 
  ## https://www.rdocumentation.org/packages/caret/versions/4.47/topics/train 
  set.seed(100)
  model <- train(trainDat[,predictors],trainDat[,response],method="rf",
                 trControl=trainControl(method="cv"),importance=TRUE)
  
  # model prediction 
  ## model is applied on the full raster stack using the predict function from the raster package
  prediction <- predict(landsat,model)
  
  # model validation 
  pred_valid <- predict(model,testDat)
  pred_valid
  #table(testDat$class,pred_valid)
  
  classified <- writeRaster(prediction, filename = paste("data/",scene,"/classified",sep = ""), format = "GTiff", options=c("COMPRESS=NONE", "TFW=YES"), overwrite = TRUE)
  
  return(classified)
}

area_calculation <- function(data_folder, landsat) {
  # classification calculation 
  classified <- classify(data_folder, landsat)

  # crop the classified raster by a shapefile to focus on the Hintertux Glacier 
  HintertuxGlacierExtent <- readOGR("data/HintertuxGlacierExtent.shp")
  
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











