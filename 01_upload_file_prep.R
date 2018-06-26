###########################################
##Code: 01_upload_file_prep.R
##Project: Upload File Prep
##Description: Add a setClass to deal if the value column has numbers, but makes it less flexible since you have to make sure the colnames match
##Author: Susannah
##Date: March 2018
############################################

rm(list=ls())
getwd()
setwd("Z:/Admin Charlottesville/Temp/Temp - Susannah/USB Q2 2017 upload files")

setClass("num.with.commas")
setAs("character", "num.with.commas", 
      function(from) as.numeric(gsub(",", "", from) ) )


data <- read.csv(file = "TV Brand - Remapped - XMedia - 02082018.csv",
                   header = TRUE,
                   colClasses = c(Period = "character",
                                 Region = "character",
                                 Product = "character",
                                 Variable = "character",
                                 Value = "num.with.commas",
                                 Segment = "character",
                                 Period = "character"),
                 na.strings = "NA")
head(data)

