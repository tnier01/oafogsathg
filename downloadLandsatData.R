########  Loading different libarys  ######## 
library(getSpatialData)

######## downloading the landsat data ########
# setting the path were all files were saved 
setwd("...")

## Define an AOI (either matrix, sf or sp object) - point of interest 
data("aoi_data") # example aoi

aoi <- aoi_data[[3]] # AOI as matrix object, or better:
aoi <- aoi_data[[2]] # AOI as sp object, or:
aoi <- aoi_data[[1]] # AOI as sf object
#instead, you could define an AOI yourself, e.g. as simple matrix

## set AOI for this session
set_aoi() # here the point of interest is set 
view_aoi() # view AOI in viewer, which will look like this

login_USGS(username="#TODO") # input of username 
set_archive("#TODO") # set archive link 

records <- getLandsat_query(time_range = c("2019-09-20", "2019-09-22"), 
                            platform = "Landsat-8") # Landsat_8_C1 

## Filter the records
colnames(records) #see all available filter attributes
# unique(records$processinglevel) #use one filter and see whats possible 
# unique(records$StartTime)
unique(records$acquisitionDate)

records_filtered2 <- records[which(records$acquisitionDate == "2019-09-21"),] # modify record on a certain date 
# View(records_filtered2) # view metadata of filtered record 

## Preview of the data 
# getLandsat_preview(record=records_filtered2) # preview with AOI 
# getLandsat_preview(record=records_filtered2, show_aoi=FALSE) # preview without AOI 
# getLandsat_preview(record = records_filtered2, on_map = FALSE) # without map 
getLandsat_preview(record = records_filtered2, show_aoi=TRUE, on_map = FALSE)

## Download some datasets to your archive directory
datasets <- getLandsat_data(records = records_filtered2)
files <- getLandsat_data(espa_order = "espa-t_nier01@uni-muenster.de-12162019-092527-958") # if you interrupt the function, you can download the data later after it is recieved from ESPA
# plotting the aerosol band 
first1 <- raster("/Users/tom/Desktop/Bsc.Geoinformatik/5.Semester/RemoteSensingBasedAnalysisOfEnvironmentalChange/data/LC08_L1TP_192027_20190921_20190926_01_T1/LC08_L1TP_192027_20190921_20190926_01_T1_B1.TIF")
first1 
plot(first1, main="Hintertux 2019.09.21")
