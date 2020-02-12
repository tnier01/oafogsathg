#### A project as part of the Study project "Remote sensing based analysis of environmental change" in the winter term 2019/ 2020 at the [Institute for Geoinformatics](https://www.ifgi.de) at the university of Muenster.

##### The aim was to determine the development of the ice-area at the Hintertux Glacier. This way  our someway provocative research question was: "Is the Hintertux Glacier shrinking?". 

## GitHub Repository
[oafogsathg](https://github.com/tnier01/oafogsathg)

## getting Started
1. clone the repository. 
2. download the landsat data by using the earthexplorer (https://earthexplorer.usgs.gov/) (optional: use the "downloadLandsatData.R" to downlad the landsat data, you have to customize several things like username and archivelink in the script. Besides there are not loaded the thermal bands, so you have to customize the "preparation.R"-file because a few bands are missing. If you download the landsat data from the hompage earthexplorer, you do not need the "downloadLandsatData.R" file)
* make sure that your are downloading "Landsat 8 OLI/TIRS C1 Level-1" and not "Landsat 8 OlI/TIRS C1 Level-2" because otherwise there will be propably problems because you can not use the thermal bands
* make sure that you download "T1" and not "T2" data, you can control that by the ending of the name of your downloaded data 
* suggestion for Hintertux glacier without clouds: (LC08_L1TP_193027_20190827_20190903_01_T1, LC08_L1TP_192027_20160827_20170321_01_T1,  	LC08_L1TP_192027_20130904_20170502_01_T1)
LC08_L1TP_192027_20170830_20170914_01_T1, LC08_L1TP_193027_20150901_20170404_01_T1, LC08_L1TP_192027_20130904_20170502_01_T1
3. create in the oafogsathg-directory a new directory called "data"
4. After unzipping the downloaded landsat data, save the corresponding folder in the data directory 
* do not change the folder name of the downloaded landsat data!!!
5. Check at the beginning of all scripts, if all librarys needed are installed, if not install them 
6. Excecute the "analysis.R"-file
* for each downloaded landsat dataset you have to run the "analysis.R"-script individually. Corresponding you have to change the name of the current landsat data folder in line 8, a further hint is in the script
* Save the year and value for each year you like to use for prediction and input them in 
the prediction.R-script 
7. The prediction.R-script already contains values for 2019 and partly 2016 which we have calculated with the method described above
* Either you adapt the given data by your own collected data or use our collected data 
* You can simply run the script by yourself and see the results in different plots 
8. further hints 
* For the classification we used a precalculated model. The model is saved under dataSurveyArea/model_20190827.Rds. This model is calculated on the data of the 27.08.2019. You can calculate your own model by the "trainModel.R"-script and use it instead of our precalcualted script. For the process in the "trainModel.R"-script you need some training sites data, which we also provide for the default model. If you like to calculate them on your own, the process is described below (create training sites in QGIS (click instructions))
* If you like to adapt the scripts, remember that all necessary presteps have been taken to ensure that all necessary precursors are available at this point 

## create training sites in QGIS (click instructions)
- used QGIS3.8
- drag "rstackCropGrid.grd"-file which you should find in your landsat data directory into a new project in QGIS 
- open Layerproperties
- use following bands:
  - red: band 3
  - green: band 2
  - blue: band 1
- third symbol second row from left "new shapefile layer"
- specify name, including path on your PC
* the name must be as follows: training_sites
* the directory must be: .../oafogsathg/data/training_sites
- file encoding: UTF-8
- geometry type: Polygon
- additionally dimension: none 
- coordinate system: WGS 84 / UTM zone 33N EPSG: 32633
- then create new field 
- name: class -> Add to field list 
- click "Ok" 
- 8th Symbol second row from left "switch edit-mode"
- 10th Symbol second row from left "add polygon object"
- draw a polygon for an area which looks similar 
- with right click define as class with id 1 (ascending for further areas) and assign corresponding class name e.g. forest
* use at least the following six classes: "forest", "grassland", "ice", "lake", "snow", "stone"
- finally save (first row, third point from left) then files are updated at the corresponding location 
- now proceed the process in the "analysis.R"-file 

## authors
* [nier](https://github.com/tnier01/)
* [sten](https://github.com/jsten07)
* [baec](https://github.com/Leverkusen)
