###########################################
##Code: 00_sql.R
##Project: General
##Description: Importing/Exporting Data from R to SQL
##Author: Susannah Derr
##Date: March 9, 2018
############################################
rm(list=ls())
setwd()

#https://docs.microsoft.com/en-us/sql/advanced-analytics/tutorials/deepdive-work-with-sql-server-data-using-r

install.packages("RODBC")
library(RODBC)

#rconnection was created in SQL using  the tutorial at https://andersspur.wordpress.com/2013/11/26/connect-r-to-sql-server-2012-and-14/
#It's default connection is to WhiteWaveSB

##Open the connection with the database
odbcChannel <- odbcConnect("rconnection",)

query <-"select top 100 FROM rconnection.dm_hadr_database_replica_states "

##See all tables in the database
sqlTables(odbcChannel)

sqlFetch(odbcChannel,"dm_hadr_database_replica_states")
data <- sqlQuery(odbcChannel,"SELECT TOP 100 FROM import_banner")

View(data)

##Close the connection with the database when you're done
odbcClose(odbcChannel)
