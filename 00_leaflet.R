###########################################
##Code: 00_geospatial.R
##Project: Geospatial Data in R
##Description: Using leaflet
##Author: Susannah Derr
##Date: March 6, 2018
############################################

rm(list=ls())
getwd()
setwd()

#install.packages("leaflet")
#install.packages("noncensus")
#install.packages("maps")
library(leaflet)
library(noncensus
library(dplyr)

##You can use package noncensus for getting US census data including zip codes/states etc.


m<-leaflet() %>% 
  setView(lng=-71.0589,lat=42.3601,zoom=12) %>%
  addTiles() %>% #Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852,popup="The birthplace of R")

m

leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag)

##Make a custom icon
greenLeafIcon <- makeIcon(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(data=quakes[1:4,]) %>%
  addTiles() %>%
  addMarkers(~long,~lat,icon=greenLeafIcon)
##Get 
zip_codes
ny_zips <- zip_codes %>% filter(state =="NY")
rm(zip_codes)
View(ny_zips)
