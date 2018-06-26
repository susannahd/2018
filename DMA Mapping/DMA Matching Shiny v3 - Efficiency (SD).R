###########################################
##Code: DMA Matching Shiny v2.R
##Project: Data Prep Portal
##Description: Maps DMAs to Nielsen/IRI markets
##Author: Susannah Derr
##Date: April 18, 2018
##Last Edit: April 30,2018
############################################
rm(list = ls())

library(stringr)
library(dplyr)
library(stringdist)
library(shiny)
library(data.table)

dma<-read.csv("S:/R Training/dma_map.csv",stringsAsFactors = FALSE,check.names = FALSE)

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("DMA Market Mapping"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File With DMAs To Map",
                multiple = TRUE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Select the column that contains your DMAs ----
      selectInput("dma_select",
                  label = "Select DMA Column",
                  choices = c(`Choose CSV File First` = "head")
      ),
      # Horizontal line ----
      tags$hr(),
      
      checkboxGroupInput("mapping",
                         label = "Select Desired Mapping(s)",
                         choices = c('Nielsen Market - Abbreviated','Nielsen Market - Full Name','IRI Market - Abbreviated','TVHHPercent')
      ),
      textOutput("txt")
      ,
      
      # Horizontal line ----
      tags$hr(),
      
      
      downloadButton('downloadData', 'Download Transformed')
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      #Output: Tabset w/ Raw csv and Transformed Data
      tabsetPanel(type = "tabs",
                  tabPanel("Raw",tableOutput("contents")),
                  tabPanel("Transformed",tableOutput("transformed"))
      )
      
    )
  )
)

# Define server logic to read selected file ----
server <- function(input, output,session) {
  
  
  output$contents <- renderTable({
    
    req(input$file1)
    
    df<-fread(input$file1$datapath,check.names = FALSE,stringsAsFactors = FALSE)
    
  })
  
  
  inFile <- reactive({
    if (is.null(input$file1)) {
      return(NULL)
    } else {
      input$file1
    }
  })
  
  myData<-reactive({
    if (is.null(inFile())) {
      return(NULL)
    } else {
      read.csv(inFile()$datapath)
    }
  })
  
  observe({
    updateSelectInput(
      session,
      "dma_select",
      choices = names(myData()))
  })
  
  map_cols <- reactive({
    if(is.null(input$mapping)) {
      return()
    } else {
      which(colnames(dma) %in%(input$mapping))
    }
  })

 transformed_data<-reactive({
     if (is.null(map_cols())) {
      return("Please make sure you've uploaded an input file and selected at least one mapping.")
    } else {
      
      df<-myData()
      df[[input$dma_select]] <-str_trim(df[[input$dma_select]])
      df[[input$dma_select]] <-str_to_upper(df[[input$dma_select]])
      df[[input$dma_select]]<-gsub("\\."," ", df[[input$dma_select]])
      df[[input$dma_select]]<-gsub(",","", df[[input$dma_select]])
      df[[input$dma_select]]<-gsub("-"," ",df[[input$dma_select]])
      df[[input$dma_select]]<-gsub("NULL","Unknown",df[[input$dma_select]])
      
      ##UPDATE: CREATE TEMP LOOKUP FILE BEFORE MAPPING OUT
      
      tmp_map<-as.data.frame(unique(df[[input$dma_select]]))
      names(tmp_map) <-input$dma_select
      
    #Merge the unique DMAs in your input file with the DMA mapping file to speed up merge
      dma <-dma %>% select(DMA_COL, map_cols())
      dat<-merge(tmp_map,dma,by=NULL)
      
    #Take the stringdistance between original DMA column and mapping DMA column
      dat$dist<-stringdist(dat$DMA_COL,dat[[input$dma_select]],method = "jw",p=0.1)
      
    #Group by DMA and take the minimum distance, select to order columns and rename for clarity      
      dat <-dat %>% 
      group_by_(.dots=names(tmp_map)) %>%
      slice(which.min(dist)) %>%
      rename(transformed_dma = DMA_COL) %>%
      arrange(desc(dist))%>%
      select(-dist)
      
    ##Replace the DMAs that are wrongly categorized
      dat$transformed_dma[dat[[input$dma_select]] == "No Metro"] <-"No Metro"
      dat$transformed_dma[dat[[input$dma_select]] %in% c("(blank)","","NULL","Unknown","UNKNOWN","#N/A")] <- "UNKNOWN"
      dat$transformed_dma[dat[[input$dma_select]] %in% c("Columbus-Ga","Columbus, GA")] <- "Columbus Ga (Opelika Al)"
      
    ##Replace Nielsen Food Markets
      if('Nielsen Market - Full Name' %in% input$mapping){
        dat$`Nielsen Market - Full Name`[dat[[input$dma_select]] == "No Metro"] <-"No Metro"
        dat$`Nielsen Market - Full Name`[dat[[input$dma_select]] %in% c("(blank)","","Unknown","UNKNOWN","#N/A")] <- "UNKNOWN"
        dat$`Nielsen Market - Full Name`[dat[[input$dma_select]] %in% c("Columbus-Ga","Columbus, GA")] <- "REMAINING US FOOD"}
      
    ##Replace Nielsen Food abbreviations
      if ('Nielsen Market - Abbreviated' %in% input$mapping){
      dat$`Nielsen Market - Abbreviated`[dat[[input$dma_select]] == "No Metro"] <-"No Metro"
      dat$`Nielsen Market - Abbreviated`[dat[[input$dma_select]] %in% c("(blank)","","Unknown","UNKNOWN","#N/A")] <- "UNKNOWN"
      dat$`Nielsen Market - Abbreviated`[dat[[input$dma_select]] %in% c("Columbus-Ga","Columbus, GA")] <- "RUS"}
      
    ##Replace IRI Market Assignments
      if ('IRI Market - Abbreviated' %in% input$mapping){
      dat$`IRI Market - Abbreviated`[dat[[input$dma_select]] == "No Metro"] <-"No Metro"
      dat$`IRI Market - Abbreviated`[dat[[input$dma_select]] %in% c("(blank)","","Unknown","UNKNOWN","#N/A")] <- "UNKNOWN"
      dat$`IRI Market - Abbreviated`[dat[[input$dma_select]] %in% c("Columbus-Ga","Columbus, GA")] <- "RUS"}
      
      dat<-inner_join(df,dat,by = input$dma_select)
      
    }
  })
  
  output$transformed <-renderTable({
    
    req(input$file1)
    
    transformed_data()
    
  })
  
  # Downloadable csv of transformed data ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(str_sub(inFile(),end=-5),"_dmamappeR_",Sys.Date(),".csv", sep = "")
    },
    content = function(file) {
      write.csv(transformed_data(), file, row.names = FALSE)
    }
  )
  
}
# Create Shiny app ----
shinyApp(ui, server)

     