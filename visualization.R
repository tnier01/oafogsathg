library(raster)

classified_2019 <- raster("data/LC08_L1TP_193027_20190827_20190903_01_T1/classified.tif")

spplot(classified_2019,col.regions=c("black","darkgreen","green","gray", "blue","white"))
spplot(classified_2019,col.regions=c("black","darkgreen","green","gray", "blue","white"), maxpixels=100000)


classified_2016 <- raster("data/LC08_L1TP_192027_20160827_20170321_01_T1/classified.tif")

spplot(classified_2016,col.regions=c("black","darkgreen","green","gray", "blue","white"))
spplot(classified_2016,col.regions=c("black","darkgreen","green","gray", "blue","white"), maxpixels=100000)


classified_2013 <- raster("data/LC08_L1TP_192027_20130904_20170502_01_T1/classified.tif")

spplot(classified_2013,col.regions=c("black","darkgreen","green","gray", "blue","white"))
spplot(classified_2013,col.regions=c("black","darkgreen","green","gray", "blue","white"), maxpixels=100000)
