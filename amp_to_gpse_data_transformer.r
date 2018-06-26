##################################################################
#       R Script for Transforming AMP Data to GPSe Data          #
#           Written by Mike Piserchia - 8/22/2017                #
#  (Please do not hesitate to Skype or email me with questions)  #
##################################################################

##################################################################
# Steps to transform data:                                       #
# 1. Create a folder on your desktop titled "data".              #
# 2. Drop all files to be transformed into the "data" folder.    #
#    The files can be a mix of AMP upload format and AMP         #
#    "model data" download format, or exclusively one format.    #
# 3. Highlight and run this entire script.                       #
#                                                                #
# NB: Transformed dataset will be exported to your desktop.      #
# The datasets that were dropped into the 'data' folder will be  #
# cleared. If clearing the old datasets is not desired and       #
# you would like the AMP files to remain in the "data" folder,   #
# put a '#' at the start of line 127 before running.             #
##################################################################
optimus_prime <- function() {
  cat("I am Optimus Prime, leader of the Autobots. I have come to Earth to transform your data...")
###########################################################################################################################################
setwd(file.path(Sys.getenv("USERPROFILE"),"Desktop/data"))
suppressWarnings(suppressMessages(library(plyr)))

ip <- as.data.frame(installed.packages()[,c(1,3:4)])
rownames(ip) <- NULL
ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]

if(any(as.vector(ip[,1]) == "plyr")){
  library(plyr)
} else{
  install.packages("plyr")
  library(plyr)
}
###########################################################################################################################################
file_names <- list.files(pattern=".csv$") 
list.data<-list() ; amp_output_list <- list() ; amp_ready_list <- list()
for (i in 1:length(file_names)){ 
  if(colnames(read.csv(file_names[i]))[[1]] == "X"){
    amp_output_list[[i]] <-read.csv(file_names[i], stringsAsFactors=F, header=F) 
  } else{
    amp_ready_list[[i]] <- read.csv(file_names[i], header=T) 
  }   
} 

amp_ready_list <- amp_ready_list[!sapply(amp_ready_list, is.null)] 
amp_output_list <- amp_output_list[!sapply(amp_output_list, is.null)] 
###########################################################################################################################################
if(length(amp_ready_list) != 0){

gpse_data<- list()
for(j in 1:length(amp_ready_list)){
  
  data <- amp_ready_list[[j]]
  
  number_of_variables <- ncol(data) - 3
  
  var_list <- list() ; var_name_list <- list()
  for(i in 4:ncol(data)){
    var_list[[i]] <- data[,i]
    var_name_list[[i]] <- rep(colnames(data)[i], nrow(data))
  }
  
  var_vec <- unlist(var_list)
  var_name_vec <- unlist(var_name_list)
  
  data_stacks <- do.call("rbind", replicate(number_of_variables, data[,c(1,2,3)], simplify = FALSE))

  gpse_data[[j]] <- cbind(data_stacks, var_name_vec, var_vec)   

}

df.amp.ready <- ldply(gpse_data, data.frame)
colnames(df.amp.ready) <- c("Product", "Market", "Period", "Variable", "Value")
df.amp.ready <- df.amp.ready[c(3,2,1,4,5)]
} else{
  df.amp.ready <- NULL
}
###########################################################################################################################################
if(length(amp_output_list) != 0){
  
gpse_data_2 <- list()
for(j in 1:length(amp_output_list)){

  data <- amp_output_list[[j]]
  
  number_of_dates <- length(unique(data$V1[4:nrow(data)]))
  number_of_markets <- length(unique(data$V2[4:nrow(data)]))
  number_of_variables <- ncol(data) - 2
  
  var_list <- list() ; tactic_list <- list() ; activity_list <- list()
  for(i in 3:ncol(data)){
    var_list[[i]] <- data[4:nrow(data),i]
    tactic_list[[i]] <-   rep(data[2,i], number_of_dates*number_of_markets)  
    activity_list[[i]] <-   rep(paste0(data[2,i], ".", data[3,i]), number_of_dates*number_of_markets) 
  }
  

  
  var_vec <- unlist(var_list)
  tactic_vec <- unlist(tactic_list)
  activity_vec <- unlist(activity_list)
  date_vec <- rep(data[4:nrow(data),1], number_of_variables)
  market_vec <- rep(data[4:nrow(data),2], number_of_variables)
  
  GPSe_data <- as.data.frame(cbind(date_vec, market_vec, tactic_vec, activity_vec, var_vec))
  colnames(GPSe_data) <- c("Period", "Market", "Product", "Variable", "Value")
  GPSe_data$Value <- as.character(GPSe_data$Value)  
  
  gpse_data_2[[j]] <- GPSe_data
}
df.amp.output <- ldply(gpse_data_2, data.frame)
}  else{
  df.amp.output <- NULL
}

###########################################################################################################################################
final_dataset <- rbind(df.amp.output,df.amp.ready)
final_dataset[final_dataset$Value == "-",5] <- 0
final_dataset_no_zeros<- final_dataset[final_dataset$Value != 0,]

export_path <- paste0(file.path(Sys.getenv("USERPROFILE"),"Desktop"), "/", "GPSe_data ", gsub(":", ".", Sys.time()), ".csv")
write.csv(final_dataset_no_zeros, file = export_path, row.names = FALSE)

#file.remove(file_names)
###########################################################################################################################################
cat("your data has been transformed.")
}
optimus_prime()