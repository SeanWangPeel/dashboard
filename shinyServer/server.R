
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)


shinyServer(function(input, output) {
  source('stock.R', local = TRUE)
  output$dashboard <- renderTable({
    report
  })
  

})
