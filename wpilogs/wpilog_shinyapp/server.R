#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
getwd()

load("../data/champs_qm108.rda")

# Define server logic required to draw a histogram
function(input, output, session) {
    
    output$selected <- renderPrint({
        input$column
    })

    output$distPlot <- renderPlot({
        
        selected_time_start <- 100
        selected_time_end <- 300
        
        
        selected_b <- champs_qm108 |>
            select(Timestamp, all_of(hist(df[[input$column]]))) |>
            mutate(Timestamp = as.numeric(Timestamp),
                   across(all_of(selected_columns),
                    ~ as.numeric(as.character(.x))),
                Timestamp = floor(Timestamp * 10) / 10) |>
            filter(between(
                Timestamp,
                selected_time_start,
                selected_time_end
                )) |>
            group_by(Timestamp) |>
            summarise(
                across(
                    all_of(selected_columns),
                    ~ mean(.x, na.rm = TRUE)
                ), .groups = "drop")
        
        pivoted_b <- selected_b |>
            pivot_longer(
                cols = all_of(selected_columns),
                names_to = "name",
                values_to = "value")
        
        ggplot(pivoted_b, aes(x = Timestamp, y = value, color = name)) +
            geom_line() +
            labs(
                title = "Back Right Supply Current",
                x = "Time",
                y = "Amps",
                color = "Current Type"
            ) +
            scale_color_manual(
                values = c("red", "blue"),
                labels = c(
                    "Drive Supply Current",
                    "Steer Supply Current"
                )
            )
    })

}
