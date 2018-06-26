###########################################
##Code:00_us_bank_qc.R
##Project: US Bank
##Description: Transposes data to QC differences between offline, online and Total Channel
##Author: Susannah Derr
##Date: March 2, 2018
############################################

rm(list=ls())
getwd()
setwd("Z:/Admin Charlottesville/Temp/Temp - Susannah")

##If you haven't installed dplyr and reshape2, uncomment the 2 lines below and run them first.
##install.packages("dplyr")
##install.packages("reshape2)
library(dplyr)
library(reshape2)
#install.packages("data.table")
library(data.table)
###############
##USER INPUT##
##############
#What is the name of the csv you want to transpose? Please put in quotes.
csv_read <-"checking_q3_2017_v2.csv"

#Import data (This code is for downloading Model Data from GPSe)
data <- fread(csv_read)

View(data)
##############################################
##NO MODIFICATIONS BEYOND THIS POINT,PLEASE!##
##############################################

#Deselect System Constant, and melt data with key variables of Period, Region, Segment, Product and Channel
test<-data %>% 
  select(-`System Constant`) %>% 
  melt(id.vars=c("Period","Region","Segment","Product","Channel"))


#Use dcast to get each Channel type as a column to make it easier to compare values
#Any variable immediately preceding a + will show up as a column
#The variable immediately preceding a ~ will have it's values turned into columns
#The value.var is the values that you want to populate your new columns
test2<-test %>%
  dcast(Period+Region+Segment+Product+variable~Channel,value.var="value")

#Find any cases where online and offline don't match. The output should only include the dependent column; if not, something's wrong
test3<-test2 %>% 
  filter(online !=offline)

#Find differences between Total Channel and online 
test4<-test2 %>% 
  mutate(tot_minus_online = `total channel`-online,tot_minus_offline = `total channel`-offline) %>%
  filter(tot_minus_online != 0|tot_minus_offline !=0)
  
View(test4)

##Write out your csv, this will be saved to your setwd()
write.csv(test4,"checking_q3_2017_qc.csv",row.names = FALSE)


##ONCE YOU'VE CHECKED test,test2 and test3, remove the data##
rm(data)
rm(test2)
rm(test3)
