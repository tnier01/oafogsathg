######## trainModel script ########
# Optional script for calculating a model for the classification. 
# For the classification we used a precalculated model. The model is saved under dataSurveyArea/model_20190827.Rds. 
# This model is calculated on the data of the 27.08.2019. You can calculate your own model by the this script and use it instead of our precalcualted script. 
# For the process in the script you need some training sites data, which we also provide for the default model. 
# If you like to calculate them on your own, the process is described in the README.md (create training sites in QGIS (click instructions))
# model training based on: https://github.com/HannaMeyer/Geostat2018/tree/master/practice


########  Loading different libarys  ######## 
library(raster)
library(sf)
library(raster)
library(train)


######## functions ######## 
#1# function 
scene <- "LC08_L1TP_193027_20190827_20190903_01_T1"

landsat <- stack("data/LC08_L1TP_193027_20190827_20190903_01_T1/rstackCropGridNoShadow.grd")

trainModel <- function(scene, landsat) {
  
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
  
  saveRDS(model, file="dataSurveyArea/model.Rds")
  
  return(model)
  
  # model validation 
  pred_valid <- predict(model,testDat)
  pred_valid
  
  #table(testDat$class,pred_valid)
}

trainModel(data_folder, landsat)

