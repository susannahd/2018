###########################################
##Code: dma_map.R
##Project: Any
##Description: Convert Nielsen DMAs to IRi MULOs
##Author: Susannah Derr
##Date: March 9, 2018
############################################
rm(list=ls())

###INPUT THE FOLDER OF YOUR FILE WITH DMAs IN QUOTATION MARKS
my_dir <-""

##INPUT THE FILE NAME
input<-"sample.csv"

##INPUT THE DMA COLUMN NAME
dma_column <-"market_name"

##INPUT YOUR DESIRED MAPPING as "Nielsen" or "IRI"
desired_mapping <-"Nielsen"


######################################
##NO MODIFICATIONS BEYOND THIS POINT##
######################################
setwd("")
library(dplyr)
library(stringr)
library(stringdist)
############################

##MAPPING
mapping <- read.csv("dma_mapping.csv",
                  check.names = FALSE,
                  header=TRUE)

##Rename columns
mapping <- mapping %>%
  unique() %>%
  mutate(match_dma = DMAName)

##Substitute some characters for similarity
mapping$match_dma <-str_to_upper(mapping$match_dma)
mapping$match_dma<-gsub("\\."," ", mapping$match_dma)
mapping$match_dma<-gsub("/"," ", mapping$match_dma)
mapping$match_dma<-gsub(",","", mapping$match_dma)
mapping$match_dma<-gsub("-"," ", mapping$match_dma)

#################################
##Read in input csv
input <- read.csv(file.path(my_dir,input),
                    check.names = FALSE,
                    header=TRUE)

##Rename columns
input_dma<-unique(input[[dma_column]])


##Substitute some characters for similarity
input_dma <-str_to_upper(input_dma)
input_dma<-gsub("\\."," ", input_dma)
input_dma<-gsub("/"," ", input_dma)
input_dma<-gsub(",","", input_dma)
input_dma<-gsub("-"," ",input_dma)

##Cross join to generate each combination
data<-merge(input_dma, mapping,by=NULL)

##Calculate string distance
data$dist<-stringdist(data$x,data$match_dma,method="jw",p=0.1)

##Filter for bad matches
data<- data %>% 
  unique() %>%
  rename(new_dma = x) %>%
  arrange(new_dma,desc(dist)) %>%
  group_by(new_dma) %>%
  slice(which.min(dist))

View(data)

grep("^",data$DMAName)
