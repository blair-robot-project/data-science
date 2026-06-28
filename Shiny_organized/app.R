library(shiny)
library(bslib)
library(googlesheets4)

data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

#functions
time_fixer <- function(a_number) {
  a_string <- as.character(a_number)
  new_string <- substring(a_string, 11)
  return(new_string)
}

#ui
ui <- fluidPage(
  titlePanel("Attendance"),
  mainPanel(
    tableOutput("attendanceTable")
  )
)

#server
server <- function(input, output) {
  output$attendanceTable <- renderTable({
    fixed_data <- data_sheet |>
      mutate(Time = time_fixer(Time))
  })
}

shinyApp(ui = ui, server = server)

