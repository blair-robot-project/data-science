library(shiny)
library(bslib)
library(googlesheets4)
library(dplyr)

server <- function(input, output) {
    output$attendanceTable <- renderTable({
        new_data
    })
    output$summaryTable <- renderTable({
        summary_data
    })
    output$individual_graph <- renderPlot({
        
    })
}