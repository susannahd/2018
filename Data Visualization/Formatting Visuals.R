###########################################
##Code:
##Project:
##Description:
##Author:
##Date:
############################################

library(ggplot2) ##For plotting
library(reshape2) ##For melt() (and reshaping data)

##Make a data frame from scratch
df <- structure(list(City = structure(c(2L,3L, 1L),.Label = c("Minneapolis", "Phoenix","Raleigh"), class = "factor"),
                     January = c(52.1,40.5, 12.2),
                     February = c(55.1, 42.2, 16.5),
                     March = c(59.7, 49.2, 28.3), 
                     April = c(67.7,59.5, 45.1), 
                     May = c(76.3, 67.4, 57.1),
                     June = c(84.6, 74.4, 66.9), 
                     July = c(91.2,77.5, 71.9), 
                     August = c(89.1, 76.5,70.2), 
                     September = c(83.8, 70.6, 60),
                     October = c(72.2, 60.2, 50),
                     November = c(59.8,50, 32.4),
                     December = c(52.5, 41.2,18.6)),
                    .Names = c("City", "January","February", "March", 
                               "April", "May", "June","July", "August", 
                               "September", "October","November", "December"),
                class = "data.frame", row.names = c(NA, -3L))

View(df)
##It's just temperatures by month by city


##We can "melt" the data from wide to long format (think of the data literally melting and falling due to gravity)
dfm <- melt(df, variable.name = "month",value.name = "temp") 
##We didn't set a key value column, so reshape2 assumes that our first column is our key variable. If we want more than one key variable, we add the additional argument id.vars (e.g. dfm<-melt(df,id.vars="City",month",variable.name = ...etc.))
levels(dfm$month) <- month.abb ##We rename the values in our month column to the abbreviated month

##Create a preliminary plot
p <- ggplot(dfm, aes(month, temp, group = City,
                       colour = City)) +
  geom_line(size=2)+
  ggtitle("Average Monthly Temperatures")

p
##Format the degree
dgr_fmt <- function(x, ...) {
parse(text = paste(x, "*degree", sep = ""))
}

##Make formatting modifications to the plot
p1 <- p + 
  theme(panel.grid.minor = element_blank(), ##No grid
        panel.background = element_blank(), ##No background
        panel.border = element_rect(color="black",fill=NA), ##Add back a border
        axis.title = element_blank(), ##No axis titles
        scale_y_continuous(breaks=c(20,40,60,80,100)) ##Set breaks for y axis

##Add reference lines to a plot, annotate
p2 <-p1 +
  geom_vline(xintercept = c(2.9,5.9,8.9,11.9),color="gray",alpha=0.5) +
  geom_hline(yintercept = 32,color="gray",alpha=0.5) +
  annotate("text",x=1.2,y=35,label="Freezing",color="gray",size=4) +
  annotate("text",x=c(1.5,4.5,7.5,10.5),y=97,label=c("Winter","Spring","Summer","Autumn"),color="gray",size=4)

p2
             
             
?geom_vline()
