###########################################
##Code: 00_upc_size_regex.R
##Project: Any
##Description: Regular Expressions for Extracting Sizes from SKUs
##Author: Susannah Derr
##Date: March 12, 2018
############################################

##Remove all items from Global Environment (see upper right window in RStudio before and after)
rm(list=ls())

##Import stringr. If you do not have stringr, you'll have to run install.packages("stringr) ahead of this command
library(stringr)

##Create fake dataframe of different ways products could come in

df <- data.frame(c("UPC10","YOGURT 15oz", "PEANUTS 15OZ","CILANTRO5OZ","MILK15ounces","POTATOES30g","Butter30gNonfat"))

##Assign column name
names(df) <- "product"

##Ensure that product is a character column so that you can do string manipulation
df$product <- as.character(df$product)

##Create a new column for size by extracting the first digit plus 2 more digits if they're in the string
##Good if all SKUs are same units (e.g. 10pk, 20pk, 30pk)
df$size_just_digits <- str_extract(df$product,"\\d++") 

##Create a new column for suze by extracting EVERYTHING after the first digit
##Good if SKUs are different units (e.g. 10g, 30oz, 20pack)
df$size_digits_and_all <- str_extract(df$product,"\\d.*")
