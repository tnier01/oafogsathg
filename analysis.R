
source(paste(getwd(),"/preparation.R",sep=""))
source(paste(getwd(),"/classification.R",sep=""))


# customize the name of the landsat data folder e.g. LC08_L1TP_193027_20190827_20190903_01_T1
data_folder <- ("LC08_L1TP_192027_20130904_20170502_01_T1")

# landsat <- stack(paste(getwd(),"/data/",data_folder,"/rstackCropGrid.gri",sep=""))

###############################
###! create training sites !###
###############################



calculateAreaOfHintertuxGlacier <- function(data_folder) {
  landsat <- band_stack(data_folder)
  
  HintertuxGlacierArea <- area_calculation(data_folder, landsat)
  return(HintertuxGlacierArea)
}

HintertuxGlacierArea <- calculateAreaOfHintertuxGlacier(data_folder)
HintertuxGlacierArea


iceAndSnowArea <- getAreaFromClassified(data_folder)
iceAndSnowArea
