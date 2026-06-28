#lets do this
library(googlesheets4)
library(dplyr)

data_sheet <- read_sheet("https://docs.google.com/spreadsheets/d/1hXbsPjKuyHZYW3LuDfqaSVnZSOkykmPnVyEZ2izvgvA/edit?usp=sharing")

time_fixer <- function(a_number) {
#So like basically before I added this function it had a very wrong date 
#included, so i got rid of it so that now its just the time 
  
  a_string <- as.character(a_number)
  new_string <- substring(a_string, 11)
  return(new_string)
}
  

fixed_data <- data_sheet |>
  mutate(Time = time_fixer(Time))