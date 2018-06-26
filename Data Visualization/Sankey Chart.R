###########################################
##Code: Sankey Chart.R
##Project: Data Visualization
##Description: Build a template for creating a Sankey chart
##Author: Susannah Derr
##Date: February 2018
############################################

rm(list = ls()) ##Remove all files in my workspace
getwd() #See what my working directory is
setwd("P:/") ##Set working directory to my personal drive


##Load packages (Can create in plotly for interactivity or ggplot2)
library (ggplot2)
library(ggalluvial)
library(datasets)
library(dplyr)
library(extrafont)
loadfonts()

ap_colors <-c("navy" = "#003D6B","forest" = "#006B3F","gold" = "#F99B0C","magenta" = "#AF23A5","red" = "#E8112D","dark_red" = "#971B2F", "blue" = "#6689CC","gray" = "#97999B", "black" = "#000000","white" = "#FFFFFF")

##Sankey diagrams work when you're trying to show the flow from one set of categorical variables to another set of categorical variables. In this case, it's the flow of gender to a department. In MMM, it could be the flow of 
is_alluvial(as.data.frame(UCBAdmissions), logical = FALSE, silent = TRUE)
##alluvia indicates that the data is in a proper format for applying an alluvial (Sankey) diagram

##https://cran.r-project.org/web/packages/ggalluvial/vignettes/ggalluvial.html#fn1


ggplot(as.data.frame(UCBAdmissions),
       aes(weight = Freq, ##Variable to determine size of flows
           axis1 = Gender, ##Variable on the lefthand axis (Assuming portrait orientation)
           axis2 = Dept)) + ##Variable on the righthand axis
  geom_alluvium(aes(fill = Admit), width = 1/12) + ##How should the flows be colored
  geom_stratum(width = 1/12, color = ap_colors["black"]) + ##the width of each stratum as a proportion of distance between the axes. Defaults to 1/3.
  geom_text(stat = "stratum", label.strata = TRUE,size=4,fontface="bold") +
  scale_x_continuous(breaks = 1:2, ##1:n, where n is the number of categories you have on the left side of your x axis 
                     labels = c("Gender", "Dept")) +
  scale_fill_brewer(type = "qual", palette = "Set2") +
  ggtitle("UC Berkeley admissions and rejections, by sex and department") +
  theme(text=element_text(family="Tahoma"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.border = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(family="Tahoma",size = 10),
        legend.position = "top",
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_blank(),
        axis.ticks = element_blank())

?geom_label()
?geom_flow()
