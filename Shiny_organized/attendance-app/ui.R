library(shiny)
library(bslib)
library(googlesheets4)
library(dplyr)

#ui
ui <- fluidPage(
    theme = bs_theme(version = 5, 
                     bootswatch = "yeti",
                     bg = "#FFF1F9", 
                     fg = "#6E6D6D",
                     primary = "#E683B8",
                     secondary = "#F0B4C4"),
    titlePanel("Attendance"),
    tabsetPanel(
        tabPanel("Intro"),
        tabPanel("Raw data", tableOutput("attendanceTable")),
        tabPanel("Summary", tableOutput("summaryTable"))
    ))