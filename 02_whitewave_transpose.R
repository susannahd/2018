###########################################
##Code: 02_whitewave.R
##Project: Whitewave AMP to GPSe
##Description: Pull data in, tranpose to get variable column and value column
##Author: Susannah Derr
##Date: March 2018
############################################

rm(list=ls())
getwd()
setwd("\\\\ap\\livens\\Broomfield\\WhiteWave\\2017\\2. Data Prep\\International Delight\\National + New Market AMP upload files\\SKU Uploads\\Subtotal Food + Mass")

library(data.table)
library(dplyr)
library(reshape2)
library(stringr)

##############################################
#Create a new directory for fixed files
dir.create("fixed_files")

##Find all filenames in the directory that are csv, xlsx, or xls files.
fileNames_csv <-Sys.glob("*.csv")

##Creates extension paramter, to ensure all files are saved out as .csvs
extension = ".csv"


##Loop through each csv in the specified directory
for (fileName in fileNames_csv) {
  
  # read in a csv
  data <- read.csv(fileName,
                   header = TRUE,
                   sep = ",",
                   check.names = FALSE)
  
  colnames(data)<-str_to_lower(colnames(data))
  #Melt data to get variable column and value column. id.vars are the columns you want to keep.
  transposed<-data %>% 
    melt(id.vars=c("prod","mkt","per"))
  
  
  # Write out new csv to newly created folder:
  write.csv(transposed, 
            file = paste0("fixed_files/",fileName,extension),
            quote = FALSE,
            na = "",
            row.names = FALSE)
  
}