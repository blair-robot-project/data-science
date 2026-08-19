time_fixer <- function(a_number) {
    a_string <- as.character(a_number)
    new_string <- substring(a_string, 11)
    return(new_string)
}

hour_min_format <- function(double) {
    hour <- round(double, 0)
    mins <- round((double - hour) * 60, 0)
    sprintf("%02d:%02d", hour, mins)
    
}

process_data <- function(raw) {
    data <- raw |>
        filter(if_else(substr(StudentID, 2,3) == "WD", FALSE, TRUE)) |>
        mutate(
            time = time_fixer(Time),
            student_ID = StudentID,
            date = as.character(as.POSIXct(Date, format="%Y:%m:%d"))
        ) |>
        group_by(student_ID, date) |>
        reframe(
            time_arrived = time_fixer(
                min(as.POSIXct(time, format="%H:%M:%S"), na.rm = TRUE)),
            time_left = time_fixer(
                max(as.POSIXct(time, format="%H:%M:%S"), na.rm = TRUE)),
            time_spent = ifelse(
                time_arrived != time_left, 
                as.numeric(difftime(
                    max(as.POSIXct(time, format="%H:%M:%S"), na.rm = TRUE), 
                    min(as.POSIXct(time, format="%H:%M:%S"), na.rm = TRUE), 
                    units = "hours"), digits = 1), 
                1
            )
        ) |>
        arrange(date, time_arrived)
    
    return(data)
}


member_graph <- function(raw, selected_id) {
    data <- raw |>
        filter(student_ID %in% selected_id) |>
        mutate(student_ID = factor(student_ID))
    
    plt <- ggplot(
        data, 
        aes(x = date, y = time_spent, color = student_ID, group = student_ID)
        ) +
        geom_line() +
        geom_point() +
        theme_bw() +
        theme(legend.position = "bottom")
    
    return(plt)
}