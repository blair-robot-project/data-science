library(shiny)
library(bslib)
library(googlesheets4)
library(dplyr)
library(tidyverse)
library(ggplot2)

source("helper_functions.R")

sheet_link <- paste0(
    "https://docs.google.com/spreadsheets/d/",
    "1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/", 
    "edit?usp=sharing")
raw <- read_sheet(sheet_link)

data <- process_data(raw)

summary <- data |>
    group_by(student_ID) |>
    summarize(total = sum(time_spent)) |>
    arrange(desc(total)) |>
    mutate(total_string = hour_min_format(total))