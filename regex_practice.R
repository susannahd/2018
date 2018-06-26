###########################################
##Code:
##Project:
##Description:
##Author:
##Date:
############################################

rm(list=ls())
getwd()
setwd()

library(stringr)

#####################
##BASIC EXPRESSIONS##
#####################
#str_view() for first instance, str_view_all() for all
x <- c("apple", "banana", "pear")

##Find the string "an"
str_view(x, "an")

##############
##WILD CARDS##
##############
##Find the first instance of any character, followed by a, followed by any character
str_view(x, ".a.")

#####################
##ESCAPE CHARACTERS##
#####################
##This looks for the character ., since . normally is a wild card
str_view(x,"/.")

#############
##ANCHORING##
#############
#Anchor the regular expression so that it matches from the start or end of the string
#Start
str_view(x,"^a")
#End
str_view(x,"a$")

#To force a regular expression to only match a complete string, anchor it with both ^ and $

x<-c("apple pie","apple","apple cake")
str_view(x,"apple") #vs...
str_view(x,"^apple$")


y<-c("$^$","$^$^","^^^","$$","a")

str_view(y,"^\\$\\^\\$$")

#####################
##CHARACTER CLASSES##
#####################

#\d matches any digit... which is confusing, since you'll have to use \ to escape the \ in \d (\\d)
#\s matches any whitespce (e.g. space, tab, newline)
#[abc] matches a,b,c
#[^abc] matches anything except a,b,c... which is f***ing confusing, since we just learned ^ is the start of a string - the difference is the brackets surrounding it. 

################
##ALTERNATIVES##
################

x<-c("abc","deaf","doofy","abd")

str_view(x,"abc|d..f")








