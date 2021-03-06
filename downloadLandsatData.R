######## downloadLandsatData script ########
# This is an optional script, which you can use to downlad the landsat data with R, you have to customize several things like username and archivelink in the script. 
# Besides there are not loaded the thermal bands, so you have to customize the "preparation.R"-file because a few bands are missing. 
# If you download the landsat data from the hompage earthexplorer, you do not need the "downloadLandsatData.R" file


######## Loading different libarys ######## 
library(getSpatialData)


######## Code  ######## 
# setting the path were all files were saved 
setwd("...")

# Define an AOI (either matrix, sf or sp object) - point of interest 
data("aoi_data") # example aoi

aoi <- aoi_data[[3]] # AOI as matrix object, or better:
aoi <- aoi_data[[2]] # AOI as sp object, or:
aoi <- aoi_data[[1]] # AOI as sf object
# instead, you could define an AOI yourself, e.g. as simple matrix

# set AOI for this session
set_aoi() # here the point of interest is set 
view_aoi() # view AOI in viewer, which will look like this

login_USGS(username="#TODO") # input of username 
set_archive("#TODO") # set archive link 

records <- getLandsat_query(time_range = c("2019-09-20", "2019-09-22"), 
                            platform = "Landsat-8") # Landsat_8_C1 

# Filter the records
colnames(records) #see all available filter attributes
# unique(records$processinglevel) #use one filter and see whats possible 
# unique(records$StartTime)
unique(records$acquisitionDate)

records_filtered2 <- records[which(records$acquisitionDate == "2019-09-21"),] # modify record on a certain date 
# View(records_filtered2) # view metadata of filtered record 

# Preview of the data 
# getLandsat_preview(record=records_filtered2) # preview with AOI 
# getLandsat_preview(record=records_filtered2, show_aoi=FALSE) # preview without AOI 
# getLandsat_preview(record = records_filtered2, on_map = FALSE) # without map 
getLandsat_preview(record = records_filtered2, show_aoi=TRUE, on_map = FALSE)

# Download some datasets to your archive directory
datasets <- getLandsat_data(records = records_filtered2)
files <- getLandsat_data(espa_order = "your_espa_oder_link") # if you interrupt the function, you can download the data later after it is recieved from ESPA