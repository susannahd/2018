###########################################
##Code: prep_format.R
##Project: Any
##Description:  Format prep files to avoid common errors when uploading to GPSe
##Author: Susannah Derr
##Date: February 27,2018
############################################
rm(list=ls())
getwd()

##install.packages("stringr)
##install.packages("readxl")
##install.packages("dplyr")
##install.packages("lubridate)
library(stringr)
library(readxl)
library(dplyr)
library(lubridate)

##Set your working directory to the directory where your upload files are saved. 
setwd("Z:/Admin Charlottesville/Temp/Temp - Susannah/")

################################
##DO NOT MODIFY THE CODE BELOW##
################################

#Create a new directory for fixed files
dir.create("fixed_files")

##Find all filenames in the directory that are csv, xlsx, or xls files.
fileNames_csv <-Sys.glob("*.csv")
fileNames_xl <-Sys.glob(c("*.xlsx","*.xls"))

##Creates extension paramter, to ensure all files are saved out as .csvs
extension = ".csv"


##Loop through each csv in the specified directory
for (fileName in fileNames_csv) {
  
  # read in a csv
  data <- read.csv(fileName,
                   header = TRUE,
                   sep = ",")
  
  # Apply data manipulations
  names(data)<-str_to_lower(names(data)) ##Make all column names lower case (helps to make more uniform)
  names(data)<-gsub(" ", "_", names(data)) #Replace spaces in column names with underscores
    
  data<-data %>%
    distinct() ##Remove any duplicate data
  
  if (class(data$period) = "integer") {
    data$period<- as_date(data$period,origin=as.Date("1899-12-30"))
  }
  
  data$value<-as.numeric(as.character(data$value)) ##Make sure value is numeric, add in as.character in case value is read in as a factor.
  data$value[is.na(data$value)]<-0
  
  
  # Write out new csv to newly created folder:
  write.csv(data, 
            file = paste0("fixed_files/",fileName,extension),
            quote = FALSE,
            na = "",
            row.names = FALSE)
  
}


####################################
##Do the same thing for xlsx files##
####################################
for (fileName in fileNames_xl) {
  
  # read in an Excel file
  data <- read_excel(fileName,
                     sheet = 1,
                     col_names = TRUE
                     )
  
  # Apply data manipulations
  names(data)<-str_to_lower(names(data)) ##Make all column names lower case (helps to make more uniform)
  names(data)<-gsub(" ", "_", names(data)) #Replace spaces in column names with underscores
  
  data<-data %>%
    distinct() ##Remove any duplicate data
  
  if (class(data$period) = "integer") {
    data$period<- as_date(data$period,origin=as.Date("1899-12-30"))
  }

  data$value<-as.numeric(as.character(data$value)) ##Make sure value is numeric, add in as.character in case value is read in as a factor.
  data$value[is.na(data$value)]<-0
  
  
  # Write out new csv to newly created folder:
  write.csv(data, 
            file = paste0("fixed_files/",str_sub(fileName,1,(str_locate(fileName,".xl")[1]-1)),extension),
            quote = FALSE,
            na = "",
            row.names = FALSE)
  
}


##Check that Value, Variable, and Time dimensions are included
##Check that column names match dependent variable file
##XXXDate type cannot change across upload flies, check to make sure date is in the same format (set it to mm.dd.yy or whatever)
##If dimension member is too long, truncate (ask Nick about character limits)
##XXXCheck that files are csv, if not, output to new directory
##XXXEnsure that there are no blanks in data, if so, impute
##XXXIf column headers have spaces, replace with an underscore
##XXXSet all column headers to lower case, to avoid changes in capitalization
##XXXNo duplicated rows --> distinct()
##XXXValue column must be a number,
##XXXImpute blanks with zeroes

