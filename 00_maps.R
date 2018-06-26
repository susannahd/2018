###########################################
##Code:
##Project:
##Description:
##Author:
##Date:
############################################
rm(list=ls())
getwd()
setwd()

install.packages(c("mapdata","ggmaps"))

library(ggplot2)
library(ggmap)
library(maps) # has outlines of continents, countries, states, and counties
library(mapdata) #higher-resolution outlines


usa<-map_data("usa")

g<-ggplot() + geom_polygon(data = usa, aes(x=long,y=lat,group=group),fill="black") +
  coord_fixed(1.3)

labs<-data.frame(long=c(-122.064873,-122.306417),
                 lat=c(36.951968,47.644855),
                 names=c("SWFSC-FED","NWFSC"),
                 stringsAsFactors = FALSE
                 )

g+geom_point(data=labs,aes(x=long,y=lat),color="white",size=5) +
  geom_point(data=labs,aes(x=long,y=lat),color="yellow",size=4)

states<- map_data("state")

ggplot(data=states) +
  geom_polygon(aes(x=long,y=lat,fill=region,group=group),color="white") +
  coord_fixed(1.3)+
  guides(fill=FALSE)

