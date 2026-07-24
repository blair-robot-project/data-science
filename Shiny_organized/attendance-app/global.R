library(shiny)
library(bslib)
library(googlesheets4)
library(dplyr)


data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

#functions
time_fixer <- function(a_number) {
    a_string <- as.character(a_number)
    new_string <- substring(a_string, 11)
    return(new_string)
}
name_fixer <- function(id) {
    x <- as.character(id)
    string1 <- ifelse(grepl(" ", x), paste0(stringr::word(x, 1), stringr::word(x, 2)), x)
    return(string1)
}

#process data
new_data <- data_sheet |>
    mutate(
        Time = time_fixer(Time),
        StudentID = name_fixer(StudentID),
        Date = as.character(as.POSIXct(Date, format="%Y:%m:%d"))
    ) |>
    group_by(StudentID, Date) |>
    reframe(
        TimeSpent = as.numeric(
            difftime(
                max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE), 
                min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE), 
                units = "mins"), 
            digits = 1),
        TimeArrived = time_fixer(
            min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE)),
        TimeLeft = time_fixer(
            max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE))
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