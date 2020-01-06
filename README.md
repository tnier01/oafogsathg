#### A project as part of the Study project "Remote sensing based analysis of environmental change" in the winter term 2019/ 2020 at the [Institute for Geoinformatics](https://www.ifgi.de) at the university of Muenster.

## GitHub Repository
[oafogsathg](https://github.com/tnier01/oafogsathg)

## Getting Started
1. download the landsat data by "downloadLandsatData.R" or use the earthexplorer (https://earthexplorer.usgs.gov/)
* make sure that your are downloading "Landsat 8 OLI/TIRS C1 Level-1" and not "Landsat 8 OlI/TIRS C1 Level-2" because otherwise there will be propably problems because you can not use the thermal bands 
* make sure that you download "T1" and not "T2" data, you can control that by the ending of the name of your downloaded data 
2. prepare the data by "preparation.R"
3. use the result of the "preparation.R" and create training site in QGIS (see further instructions below)
4. use the result of the "preparation.R" and the training site for the classification of the data by "classification.R" 

## create training data in QGIS (click instructions)
- drag .grd-file obtained from "preparation.R" into a new project in QGIS 
- third symbol second row from left "new shapefile layer"
- specify name, including location on your computer: e.g. "trainingSites"
- geometry type: Polygon
- pay attention to coordinate system 
- then create new field 
- name: class -> Add to field list 
- Ok 
- 10 Symbol second row from left "add polygon object"
- draw a polygon for an area which looks similar 
- with right click define as class with id 1 (ascending for further areas) and assign corresponding class name e.g. forest 
- finally save (first row, third point from left) then files are updated at the corresponding location 
- now use the appropriate .shp-file in the "classification.R" for the variable "training"

## used data 
- LC08_L1TP_192027_20190921_20190926_01_T1
- 27.08.2019
- 27.08.2016
- 04.09.2013

## Authors
* nier
* baec
* sten
