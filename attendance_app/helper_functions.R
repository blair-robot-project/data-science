time_fixer <- function(a_number) {
    a_string <- as.character(a_number)
    new_string <- substring(a_string, 11)
    return(new_string)
}

time_rounder <- function(time) {
    h <- hour(time)
    m <- minute(time)
    
    if (h == 15 & m >= 10 & m <= 40) {
        time <- update(time, hour = 3, minute = 30, second = 0)
    }  else if (h == 17 & m >= 45) {
        time <- update(time, hour = 6, minute = 0, second = 0)
    }
    
    return(time)
}

hour_min_format <- function(double) {
    hour <- floor(double)
    mins <- floor((double - hour) * 60)
    sprintf("%02d:%02d", hour, mins)
    
}

process_data <- function(raw) {
    data <- raw |>
        filter(substr(StudentID, 2,3) != "WD") |> # Recognized person
        mutate(
            Time = time_rounder(time)
        ) |>
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
                round(as.numeric(difftime(
                    max(as.POSIXct(time, format="%H:%M:%S"), na.rm = TRUE), 
                    min(as.POSIXct(time, format="%H:%M:%S"), na.rm = TRUE), 
                    units = "hours")), digits = 2), 
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

cumulative_plot <- function(raw) {
    data <- raw |>
        group_by(date) |>
        summarize(
            total_time_daily = sum(time_spent)
        ) |>
        mutate(
            date = as.Date(date, format = "%Y-%m-%d")
        )
    
    data$cumulative_hours = round(cumsum(data$total_time_daily), 2)
    
    ggplot(data, aes(x = date, y = cumulative_hours)) +
        geom_area(fill = "#a7000a", alpha = 0.5) +
        geom_line(color = "black", size = 0.5) +
        labs(x = "Date", y = "Cumulative Hours") + 
        theme_bw()
}