library(shiny)
library(bslib)

data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

ui <- fluidPage(
  titlePanel("Attendance"),
  mainPanel(
    tableOutput("attendanceTable")
  )
)

server <- function(input, output) {
  output$attendanceTable <- renderTable({
    data_sheet
  })
}

shinyApp(ui = ui, server = server)

