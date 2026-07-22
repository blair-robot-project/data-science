#lets do this
library(googlesheets4)
library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)

data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

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


# time_fixer <- function(a_number) {
#     a_string <- as.character(a_number)
#     new_string <- substring(a_string, 12)
#     return(new_string)
# }
#
# name_fixer <- function(id) {
#     x <- as.character(id)
#     string1 <- ifelse(grepl(" ", x), paste0(stringr::word(x, 1), stringr::word(x, 2)), x)
#     return(string1)
# }
#
# fixed_data <- data_sheet |>
#     mutate(Time = time_fixer(Time),
#            StudentID = name_fixer(StudentID))
#
# new_data <- fixed_data |>
#     group_by(StudentID, Date) |>
#     reframe(TimeSpent = as.numeric(difftime(
#             max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE),
#             min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE),
#             units = "mins"), digits = 1),
#             TimeArrived = time_fixer(min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE)),
#             TimeLeft = time_fixer(max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE)))


new_data <- data_sheet |>
    mutate(Time = time_fixer(Time),
           StudentID = name_fixer(StudentID),
           Date = as.POSIXct(Date, format="%Y:%m:%d")) |>
    group_by(StudentID, Date) |>
    reframe(TimeSpent = as.numeric(difftime(
        max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE),
        min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE),
        units = "mins"), digits = 1),
        TimeArrived = time_fixer(min(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE)),
        TimeLeft = time_fixer(max(as.POSIXct(Time, format="%H:%M:%S"), na.rm = TRUE))) |>
    arrange(Date)

summary_data <- new_data |>
    group_by(StudentID) |>
    summarize(Total = floor(sum(TimeSpent))) |>
    arrange(desc(Total))

#Wouldn't it be cool if we had everyone's contributions on graphs over the scale of the year? Like an individual summary page?
#Okay, so the individual summary page would include the following:
#   - individual graph over time
#   - Total hours
#   - average hours per week (?)

member_graph <- function(
        selected_id
) {
    selected_data <- new_data |>
        filter(StudentID %in% c(selected_id)) |>
        mutate(StudentID = factor(StudentID))
    ggplot(
        selected_data,
        aes(x = Date, y = TimeSpent, color = StudentID, group = StudentID)
    ) +
        geom_line() +
        geom_point() +
        theme_bw() +
        theme(
            legend.position = "bottom",
        )
}

member_graph(c("Biscuit", "MitchellHung"))
