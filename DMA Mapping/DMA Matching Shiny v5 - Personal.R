###########################################
##Code: DMA Matching Shiny v3.R
##Project: Data Prep Portal
##Description: Maps DMAs to Nielsen/IRI markets
##Author: Susannah Derr
##Date: April 18, 2018
##Last Edit: June 19,2018
############################################

##RUN THE ENTIRE CODE BELOW BY HIGHLIGHTING ALL OF THE TEXT AND HITTING CTRL + ENTER
##A WINDOW WILL POP UP IN YOUR DEFAULT BROWSER WITH THE DMA MAPPING APP

rm(list = ls())

required_packages <- c("stringr", "stringdist", "dplyr", "shiny","readr","openxlsx")

for(i in 1:length(required_packages)){
  if(required_packages[i] %in% installed.packages()[,1]) 
  {library(required_packages[i], character.only=T)}
  else{install.packages(required_packages[1])
    library(required_packages[i], character.only=T)}  
}

dma<-read_csv("S:/R Training/dma_map.csv")
end_col<-ncol(dma)

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Geography Mapping"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Choose a CSV File to Apply Mappings to",
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
                         choices = names(dma[,3:end_col])
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
                  tabPanel("Mapping",tableOutput("mapping")),
                  tabPanel("Transformed",tableOutput("transformed"))
      )
      
    )
  )
)

# Define server logic to read selected file ----
server <- function(input, output,session) {
  
  session$onSessionEnded(stopApp)

##CREATE REACTIVE VALUE FOR INPUT DATA
  myData<-reactive({
    if (is.null(input$file1)) {
      return(NULL)
    } else {
      csv<-read_csv(input$file1$datapath,trim_ws = TRUE,col_names = TRUE)
      csv<-csv[,colSums(is.na(csv))<nrow(csv)]
      names(csv)<-make.names(names(csv),unique = TRUE)
      csv
    }
  })
  
##RENDER HEAD OF INPUT DATA
  output$contents <- renderTable({
    req(input$file1)
    head(myData(),100)
    
  })
  
##UPDATE SELECTIONS WITH DATA COLUMNS  
  observe({
    updateSelectInput(
      session,
      "dma_select",
      choices = names(myData()))
  })
  
##CREATE REACTIVE VARIABLE FOR MAP COLUMNS  
  map_cols <- reactive({
    if(is.null(input$mapping)) {
      return()
    } else {
      which(colnames(dma) %in%(input$mapping))
    }
  })

##CREATE REACTIVE VARIABLE FOR DMA  
  dma2<-reactive({
    if(is.null(map_cols())) {
      return(NULL)} 
    else{
      dma <-dma %>% select(DMA_COL,DisplayDMA, map_cols())
    }
  })
  
  df<-reactive({
    if(is.null(map_cols())) {
      return(NULL)} 
    else{
      df<-myData()
      df$manipulated_dma<-str_trim(df[[input$dma_select]])
      df$manipulated_dma<-str_to_upper(df$manipulated_dma)
      df$manipulated_dma<-gsub("\\."," ", df$manipulated_dma)
      df$manipulated_dma<-gsub("-"," ", df$manipulated_dma)
      df$manipulated_dma<-gsub("\\/"," ", df$manipulated_dma)
      df$manipulated_dma<-gsub("(?<=\\S)[aeiou]", "", df$manipulated_dma, perl = TRUE, ignore.case = TRUE)
      df
    }
  })
  
  mapping<-reactive({
    if (is.null(df())) {
      return("Please make sure you've uploaded an input file and selected at least one mapping.")
    } else {
      
      df<-df()
      dma<-dma2()

      ##UPDATE: CREATE TEMP LOOKUP FILE BEFORE MAPPING OUT
      tmp_map<-as.data.frame(unique(df$manipulated_dma))
      names(tmp_map) <-"manipulated_dma"
      
      
      #Merge the unique DMAs in your input file with the DMA mapping file to speed up merge
      dat<-merge(tmp_map,dma,by=NULL)
      
      #Take the stringdistance between original DMA column and mapping DMA column
      dat$dist<-stringdist(dat$DMA_COL,dat$manipulated_dma,method = "jw",p=0.1)
      
     
      #Group by DMA and take the minimum distance, select to order columns and rename for clarity      
      dat <-dat %>% 
       group_by_(.dots=names(tmp_map)) %>%
       slice(which.min(dist)) %>%
        rename(assumed_match_dma = DisplayDMA) %>%
        select(-DMA_COL)
      
      df<-df() %>%
        select(input$dma_select,manipulated_dma)
      
      dat<-inner_join(df,dat,by = "manipulated_dma") %>%
        unique() %>%
        select(-manipulated_dma) %>%
        arrange(desc(dist))
      
      dat
    }
  })
  
  ##DISPLAY MAPPING
  output$mapping <-renderTable({
    req(input$file1)
    mapping()
  })
  
  ##MAKE TRANSFORMED DATA    
  transformed_data<-reactive({
    if (is.null(mapping())) {
      return(NULL)
    } else {
      
      dat<-mapping()
      df<-df()
      
      dat<-inner_join(df,dat,by = input$dma_select) %>%
        select(-c(manipulated_dma,dist))
      
    }
  })
  
  output$transformed <-renderTable({
    req(input$file1)
    head(transformed_data(),100)
  })
  
  ##MAKE REACTIVE VALUE FOR LIST OF DATASETS
  list_of_datasets<-reactive({
    if(is.null(myData())) {
      return(NULL)}
    else{list("dmamappeR" = transformed_data(),"Mapping Reference" = mapping(),"Guide" = "The dist column in the Mapping Reference tab varies between 0 and 1, with lower numbers indicating higher text similarity between input DMA and transformed_dma. This tab is sorted by descending dist, such that lower quality mappings are at the top, and can be readjusted and reassigned using a VLOOKUP.")
    }
  })

  
  # Downloadable csv of transformed data ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(str_sub(input$file1,end=-5),"_dmamappeR_",Sys.Date(),".xlsx")
    },
    content = function(file) {
      write.xlsx(list_of_datasets(),file)
    }
  )
  
}
# Create Shiny app ----
shinyApp(ui, server)
