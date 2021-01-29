###########################################
##Code: 01_fred_api.R
##Project: FRED Data
##Description: Pulls data from FRED website
##Author: Susannah Derr
##Date: March 1, 2018
############################################

##PLEASE SAVE A COPY OF THIS FILE IN YOUR OWN DIRECTORY##

rm(list=ls())
getwd()

library(FredR)
library(dplyr)
library(stringr)


######################
##PARAMETERS TO EDIT##
######################

##Set to your own working directory - files will be saved here
setwd("")

##Provide your API key
api_key<-"Y0UR API KEY"

##Provide a filename to save your data as
Filename <-"Effective Federal Funds Rate Data 2017.csv"

##Provide the series_id of the dataset you'd like to download
Dataset <- "FEDFUNDS"

##Provide the start date and end date for which you'd like to pull data in the 'YYYY-MM-DD' format
Start_date <- '2016-01-01'
End_date <- '2016-12-31'

##Provide the frequency you'd like to pull data at, in quotation marks
Frequency <- 'monthly'

#######################################
##NO MODIFICATIONS BEYOND THIS POINTS##
#######################################

##Initialize FRED R
fred<-FredR(api_key)

##Pull data
data<-fred$series.observations(series_id = Dataset,observation_start =Start_date,observation_end=End_date,frequency = str_to_title(Frequency))

##Write csv to the directory specified in setwd()
write.csv(data,file=Filename)

