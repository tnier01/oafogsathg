
source(paste(getwd(),"/preparation.R",sep=""))
source(paste(getwd(),"/classification.R",sep=""))


# customize the name of the landsat data folder e.g. LC08_L1TP_193027_20190827_20190903_01_T1
data_folder <- ("LC08_L1TP_192027_20160827_20170321_01_T1")

landsat <- band_stack(data_folder)

# landsat <- stack(paste(getwd(),"/data/",data_folder,"/rstackCropGrid.gri",sep=""))

###############################
###! create training sites !###
###############################



HintertuxGlacierArea <- area_calculation(data_folder, landsat)
HintertuxGlacierArea
