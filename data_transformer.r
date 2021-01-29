##################################################################
##Transpose Data
optimus_prime <- function() {
  cat("Let's transform data...")
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
list.data<-list() ; output_list <- list() ; ready_list <- list()
for (i in 1:length(file_names)){ 
  if(colnames(read.csv(file_names[i]))[[1]] == "X"){
    output_list[[i]] <-read.csv(file_names[i], stringsAsFactors=F, header=F) 
  } else{
    ready_list[[i]] <- read.csv(file_names[i], header=T) 
  }   
} 

ready_list <- ready_list[!sapply(ready_list, is.null)] 
output_list <- output_list[!sapply(output_list, is.null)] 
###########################################################################################################################################
if(length(ready_list) != 0){

data<- list()
for(j in 1:length(ready_list)){
  
  data <- ready_list[[j]]
  
  number_of_variables <- ncol(data) - 3
  
  var_list <- list() ; var_name_list <- list()
  for(i in 4:ncol(data)){
    var_list[[i]] <- data[,i]
    var_name_list[[i]] <- rep(colnames(data)[i], nrow(data))
  }
  
  var_vec <- unlist(var_list)
  var_name_vec <- unlist(var_name_list)
  
  data_stacks <- do.call("rbind", replicate(number_of_variables, data[,c(1,2,3)], simplify = FALSE))

  data[[j]] <- cbind(data_stacks, var_name_vec, var_vec)   

}

df.ready <- ldply(data, data.frame)
colnames(df.ready) <- c("Period", "Variable", "Value")
df.ready <- df.ready[c(3,2,1,4,5)]
} else{
  df.ready <- NULL
}
###########################################################################################################################################
if(length(output_list) != 0){
  
data_2 <- list()
for(j in 1:length(output_list)){

  data <- output_list[[j]]
  
  number_of_dates <- length(unique(data$V1[4:nrow(data)]))
  number_of_markets <- length(unique(data$V2[4:nrow(data)]))
  number_of_variables <- ncol(data) - 2
  
  var_list <- list() ; tactic_list <- list() ; activity_list <- list()
  for(i in 3:ncol(data)){
    var_list[[i]] <- data[4:nrow(data),i]
    tactic_list[[i]] <-   rep(data[2,i], number_of_dates*number_of_markets)  
    activity_list[[i]] <-   rep(paste0(data[2,i], ".", data[3,i]), number_of_dates*number_of_markets) 
  }


###########################################################################################################################################
final_dataset <- test
export_path <- paste0(file.path(Sys.getenv("USERPROFILE"),"Desktop"), "/", "GPSe_data ", gsub(":", ".", Sys.time()), ".csv")
write.csv(final_dataset_no_zeros, file = export_path, row.names = FALSE)

#file.remove(file_names)
