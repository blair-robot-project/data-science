library(data.table)

getwd()
new_df <- fread("wpilogs/data/QM094.csv")
save(new_df, file = "qm094.rda")