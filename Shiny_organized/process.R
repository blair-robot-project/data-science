#lets do this
library(googlesheets4)
library(dplyr)

data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

time_fixer <- function(a_number) {
    a_string <- as.character(a_number)
    new_string <- substring(a_string, 11)
    return(new_string)
}

fixed_data <- data_sheet |>
    mutate(Time = time_fixer(Time))

new_data <- fixed_data |>
    group_by(StudentID, Date) |>
    summarize(TimeSpent = as.character(max(as.numeric(Time)) - min(as.numeric(Time))),
              TimeArrived = min(as.numeric(Time)),
              TimeLeft = max(as.numeric(Time)),
              StudentID = StudentID,
              Date = min(Date))

