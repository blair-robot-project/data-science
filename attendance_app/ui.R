ui <- fluidPage(
    theme = bs_theme(
        version = 5, 
        bootswatch = "yeti",
        bg = "#FFE9F9", 
        fg = "#6E6D6D",
        primary = "#E683A9",
        secondary = "#F0B4C4"
    ),
    titlePanel("Attendance"),
    tabsetPanel(
        tabPanel("Raw data", tableOutput("attendanceTable")),
        tabPanel("Summary", tableOutput("summaryTable")),
        tabPanel(
            title = "Individual",
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = "selected_id", 
                        label = "Choose a Student:", 
                        choices = unique(data$student_ID))
                ),
            mainPanel(plotOutput("individual_graph"))
            )
        ),
        tabPanel("Group", plotOutput("cumulative_graph"))

    ))