library(shiny)
library(bslib)
library(googlesheets4)
library(dplyr)

#ui
ui <- fluidPage(
    theme = bs_theme(
        version = 5, 
        bootswatch = "yeti",
        bg = "#FFF1F9", 
        fg = "#6E6D6D",
        primary = "#E683A9",
        secondary = "#F0B4C4"
    ),
    titlePanel("Attendance"),
    tabsetPanel(
        tabPanel("Raw data", tableOutput("attendanceTable")),
        tabPanel("Summary", tableOutput("summaryTable")),
        tabPanel(
            title = "Graphs",
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = "selected_id", 
                        label = "Choose a Student:", 
                        choices = unique(new_data$StudentID))
                ),
            mainPanel(plotOutput("individual_graph"))
            )
        )
    ))