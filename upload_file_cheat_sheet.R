###########################################
##Code:upload_file_cheat_sheet.R
##Project: US Bank
##Description: Creates a csv with each upload file name and 
##Author: Susannah Derr
##Date: March 2, 2018
############################################

rm(list=ls())
getwd()
setwd("Z:/Admin Charlottesville/Temp/Temp - Susannah/USB Q2 2017 Total Channel Upload files/Upload")

##############################
fileNames <- Sys.glob("*.csv")

for (fileName in fileNames) {
  
  # read original data:
  data <- read.csv(fileName,
                     header = TRUE,
                     sep = ",")
  
  
  # create new data based on contents of original file:
  upload_files <- data.frame(
    File = fileName,
    Channel = ifelse(sum(!is.na(data$Channel))==0,"Apply All","" ),
    Region = ifelse(sum(!is.na(data$Region))==0,"Apply All"," "),
    Product = ifelse(sum(!is.na(data$Product))==0,"Apply All"," "),
    Segment = ifelse(sum(!is.na(data$Segment))==0,"Apply All"," "),
    Variable = unique(data$Variable)
)

  # write new data to separate file:
  write.table(upload_files, 
              "upload_files.csv",
              append = TRUE,
              sep = ",",
              row.names = FALSE,
              col.names = FALSE,
              na = "")
  
}

fixit<-read.csv("upload_files.csv",header=FALSE)

colnames(fixit) = c("Files","Channel","Region","Product","Segment","Variable")

write.csv(fixit,
          "upload_files.csv",
          row.names = FALSE,
          na = "")