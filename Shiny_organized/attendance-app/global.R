library(shiny)
library(bslib)
library(googlesheets4)
library(dplyr)
library(tidyverse)
library(ggplot2)


data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

#functions
time_fixer <- function(a_number) {
    a_string <- as.character(a_number)
    new_string <- substring(a_string, 11)
    return(new_string)
}

#process data
new_data <- data_sheet |>
    filter(if_else(substr(StudentID, 2,3) == "WD", FALSE, TRUE)) |>
    mutate(
        Time = time_fixer(Time),
        StudentID = StudentID,
        Date = as.character(as.POSIXct(Date, format="%Y:%m:%d"))
    ) |>
    group_by(StudentID, Date) |>
    reframe(
        TimeArrived = time_fixer(
            min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE)),
        TimeLeft = time_fixer(
            max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE)),
        TimeSpent = ifelse(TimeArrived != TimeLeft, 
            as.numeric(
                difftime(
                    max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE), 
                    min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE), 
                    units = "hours"), 
                digits = 1), 
            1
        )
                
            
    ) |>
    arrange(Date, TimeArrived)

summary_data <- new_data |>
    group_by(StudentID) |>
    summarize(Total = sum(TimeSpent)) |>
    arrange(desc(Total))

#helper functions
member_graph <- function(
        new_data, selected_id
) {
    selected_data <- new_data |>
        filter(StudentID %in% c(selected_id)) |>
        mutate(StudentID = factor(StudentID))
    plt <- ggplot(
        selected_data,
        aes(x = Date, y = TimeSpent, color = StudentID, group = StudentID)
    ) +
        geom_line() +
        geom_point() +
        theme_bw() +
        theme(
            legend.position = "bottom",
        )
    return(plt)
}