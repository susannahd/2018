##################################################
## Code: 00_fred_api.R 
## Project: FRED Data
## Description: Trying to find a way to download FRED data through R with specified dates
## Date: March 1, 2018
## Author: Susannah Derr
##################################################
rm(list=ls())

library(dplyr)
library(reshape2)
library(stringr)
library(tidyr)

#First, you'll have to install the devtools package, which allows you, among other things, to interact with Github and APIs.
#install.packages("devtools")
#devtools::install_github("jcizel/FredR")
library(FredR)

##Apply for an API key at the FRED
api_key<-"6628be869570a07ee233d24dc03a75e1"

##Initialize FRED R
fred<-FredR(api_key)

##See all the available functions in FredR package
str(fred,1)

test<-fred$getChildrenList(category.id = 2) %>%
  data.frame() %>%
  t()
rownames(test)<-c()

View(test)
#Create an object called gdp.series that contains all data sets with "GDP" in the title
gdp.series <- fred$series.search("Effective") %>%
  select(id,title,observation_start,observation_end,realtime_start,realtime_end,popularity) %>%
  arrange(desc(as.numeric(popularity))
  )

View(gdp.series)

##Effective Federal Funds Rate
gdp<-fred$series.observations(series_id = "FEDFUNDS",observation_start = '2016-01-01',observation_end='2016-01-10')
