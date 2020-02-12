######## analysis script ########
# This is the final analysis script to be executed by the user. 
# You find further information concerning the process in the README.md. 


######## loading of some further files the "analysis.R"-script uses ########
source(paste(getwd(),"/preparation.R",sep=""))
source(paste(getwd(),"/classification.R",sep=""))

# customize the name of the landsat data folder e.g. LC08_L1TP_193027_20190827_20190903_01_T1
# use the landsat data folder instead of your_landsat_data_folder, but do not delete the ""
data_folder <- ("your_landsat_data_folder")

landsat <- stack(paste("data/",data_folder,"/rstackCropGridNoShadow.grd",sep=""))


######## functions ########
#1# function to calculate the ice + snow area at the Hintertux glacier 
# you find further information concerning the sub functions in the other R-scripts 
calculateAreaOfHintertuxGlacier <- function(data_folder) {
  
  # preperation of the data including shadow removement, 
  # projection fitting, cropping, calculating NDVI and 
  # bringing the bands together to an stack 
  # this function is called from the script preparation.R
  landsat <- band_stack(data_folder)
  
  # performing the area calculation including the classification
  # this function is called from the script classification.R 
  HintertuxGlacierArea <- area_calculation(data_folder, landsat)
  return(HintertuxGlacierArea)
}


######## result ########
# the result HintertuxGlacierArea is the area in square meters at the Hintertux Glacier which
# is covered by snow 
HintertuxGlacierArea <- calculateAreaOfHintertuxGlacier(data_folder)
HintertuxGlacierArea


iceAndSnowArea <- getAreaFromClassified(data_folder)
iceAndSnowArea
