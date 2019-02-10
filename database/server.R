library(shiny)
library(curl)
library(DT)
library(shinythemes)

x <- read.csv(curl("https://raw.githubusercontent.com/tanho63/dynastyprocess/master/files/database.csv"))
cols = c(24:32,46:51)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  df <- reactive(
    data.frame(x[,input$select, drop = FALSE])
  )
  
  output$results <- renderDT({
    datatable( df(),
               filter = 'top',
               options = list(pageLength = 50,
                              scrollX =TRUE,
                              columnDefs = list(list(className = 'dt-head-left', targets = "_all"))),
               class = 'compact stripe') %>%
      formatStyle(columns = names(dplyr::select_if(df(), is.numeric)),
                  'text-align' = 'left')
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {"DynastyProcessDatabase.csv"},
    content = function(file) {write.csv(df(), file)}
  )
  
  proxy = dataTableProxy('results')
  
  observeEvent(input$clear1, {proxy %>% clearSearch()}
  )
  
})