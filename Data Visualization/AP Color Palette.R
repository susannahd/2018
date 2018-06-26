##################################################
## Project: Custom AP Color Palette
## Script purpose: Create color palette according to marketing  materials
## Date: February 2018
## Author: Susannah Derr
##################################################
rm(list = ls())
list.of.packages <- c("rstudioapi","fBasics","grDevices")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(rstudioapi)
library(fBasics)
library(grDevices)

ap_color<- c(lightred = "#E8112D", medred = "#CE1126", darkred = "#971B2F", maroon = "#7C2128",
                yellow = "#FCD116", goldenrod = "#F99B0C", orange = "#F96B07",
              magenta = "#AF23A5", violet = "#440099", ocean = "#003D6B", medblue = "#6689CC", americansky = "#75AADB",
              grass = "#1EB53A", forest = "#006B3F", gray = "#97999B", grey = "#97999B", black = "#000000", white = "#FFFFFF")

ap_colors <-c("#E8112D", "#CE1126", "#971B2F", "#7C2128","#FCD116", "#F99B0C", "#F96B07", "#AF23A5", "#440099", "#003D6B", "#6689CC", "#75AADB","#1EB53A","#006B3F", "#97999B", "#97999B", "#000000", "#FFFFFF")

###########################################################################################################
r<- c(228, 200, 151, 118, 255, 249, 255, 154, 67, 0, 65, 108, 67, 4, 151, 0, 255)
g<- c(0, 16, 27, 35, 214, 159, 106, 58, 0, 55, 143, 172, 176, 106, 153, 0, 255)
b<- c(43, 46, 47, 47, 0, 30, 19, 149, 157, 100, 222, 228, 58, 56, 155, 0, 255)



ap_palette <- function(color="blue") {
  if (is.numeric(color)) AT_color_data[1:color[1]]
  else AT_color_data[tolower(color)]
}



ap_colors <- function (n, name = c("ap_palette")) 
{
  ap_palette = rgb(r, g, b, maxColorValue = 255)
  name = match.arg(name)
  orig = eval(parse(text = name))
  rgb = t(col2rgb(orig))
  temp = matrix(NA, ncol = 3, nrow = n)
  x = seq(0, 1, length(orig))
  xg = seq(0, 1, n)
  for (k in 1:3) {
    hold = spline(x, rgb[, k], n = n)$y
    hold[hold < 0] = 0
    hold[hold > 255] = 255
    temp[, k] = round(hold)
  }
  palette = rgb(temp[, 1], temp[, 2], temp[, 3], maxColorValue = 255)
  palette
}


