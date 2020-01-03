########  Loading different libarys  ######## 
library(raster)
library(caret)
library(mapview)
library(sf)

# setting the path were all files were saved 
## use your data folder as setwd, because there the needed file from preparation is saved 
setwd("...")

######## functions ######## 
#1# function for classifing  
classify <- function(scene) {
  
  # loading the data 
  ## landsat data prepared in preparation.R
  landsat <- stack(paste(scene,"/rstackCropGrid.grd",sep = "")) 
  ## shapefile of the training site prepared in QGIS
  training <- read_sf(paste(scene,"/training_sites.shp",sep = "")) 
  
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
  #boxplot(trainDat$LC08_L1TP_192027_20130904_20170502_01_T1_B4~trainDat$class,las=2)

  #featurePlot(x = trainDat[, c(paste(scene,"_B2",sep=""),paste(scene,"_B3",sep=""),paste(scene,"_B4",sep=""),paste(scene,"_B5",sep=""),paste(scene,"_B10",sep=""),"layer")], 
  #            y = factor(trainDat$class), 
  #            plot = "pairs",
  #            auto.key = list(columns = 4))
  
  # Model training 
  ## define predictors (all data from the landsat data - layer is here the NDVI)
  ## response variable is the "Class" column of the data frame
  predictors <- c(paste(scene,"_B2",sep=""),paste(scene,"_B3",sep=""),paste(scene,"_B4",sep=""),paste(scene,"_B5",sep=""),paste(scene,"_B10",sep=""),"layer")
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
  
  spplot(prediction,col.regions=c("darkgreen","green","black","blue",
                                  "white","gray"))     #,maxpixels=1000000)
  
  # model validation 
  pred_valid <- predict(model,testDat)
  pred_valid
  #table(testDat$class,pred_valid)
  
  writeRaster(prediction, filename = paste(scene,"/classified",sep = ""), format = "GTiff")
}

######## result ######## 
# final result of classification 
classified <- classify("LC08_L1TP_192027_20130904_20170502_01_T1")

# pixels used for different classes 
pixels <- freq(classified)
pixels

# area in square meters which is signed concerning the class ice 
ice_area <- as.numeric(pixels[3,2])*900
ice_area
