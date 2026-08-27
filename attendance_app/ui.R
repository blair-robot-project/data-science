ui <- navbarPage(
    title = "Attendance Application",
    theme = bs_theme(
        version = 5, 
        bootswatch = "yeti",
        bg = "#FFEFFF", 
        fg = "#6E6D6D",
        primary = "#E683A9",
        secondary = "#F0B4C4"
        ) |>
        bs_add_variables(
            "navbar-bg" = "#E683A9",
            "navbar-light-color" = "#6E6D6D",
            "navbar-light-active-color" = "#FFFFFF"
        ),
    collapsible = TRUE,
    
    header = tagList(
        tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
        tags$head(tags$script(HTML("
            function resizeFrame() {
                if (window.frameElement) {
                    var activeTab = document.querySelector('.tab-pane.active');
                    var navbar = document.querySelector('.navbar');
                    var navHeight = navbar ? navbar.offsetHeight : 0;
                    var h = activeTab ? activeTab.scrollHeight + navHeight + 20
                    : document.body.scrollHeight;
                    
                    window.frameElement.style.height = h + 'px';
                    window.frameElement.style.overflow = 'hidden';
                }
                document.documentElement.style.overflow = 'hidden';
                document.body.style.overflow = 'hidden';
            }

            // On tab click
            document.addEventListener('click', function(e) {
                var tab = e.target.closest('a[data-bs-toggle=\"tab\"], a[data-toggle=\"tab\"]');
                if (tab) {
                    setTimeout(resizeFrame, 400);
                }
            });
            
            // When any Shiny output finishes rendering, resize
            $(document).on('shiny:value shiny:outputinvalidated', function() {
                setTimeout(resizeFrame, 300);
            });
            
            // Watch for image/plot loads specifically
            $(document).on('shiny:idle', function() {
                setTimeout(resizeFrame, 300);
            });
            
            setTimeout(resizeFrame, 2000);"
        ))),
    ),
    tabPanel(
        title = "Raw Data",
        card(
            class = "graph-card",
            card_header("Raw"),
            card_body(
                fillable = FALSE,
                tableOutput("attendanceTable")
            )
        ),
    ),
    tabPanel(
        title = "Summary Data",
        card(
            class = "graph-card",
            card_header("Summary"),
            card_body(
                fillable = FALSE,
                tableOutput("summaryTable")
            )
        ),
    ),
    tabPanel(
         title = "Individual",
         div(class = "container-fluid",
             div(class = "row",
                 div(class = "col-12 col-lg-3",
                    div(
                        #class = "individual-picker", 
                        virtualSelectInput(
                            "selected_id", 
                            label = "Choose a Student:", 
                            choices = unique(data$student_ID), 
                            selected = 1, search = TRUE
                            )
                        )
                    ),
                 div(
                     class = "col-12 col-lg-9",
                     card(
                         class = "graph-card",
                         card_header("Individual Attendance Plot"),
                         plotOutput("individual_graph") |> 
                             withSpinner()
                     )
                 )
             )
         )
    ),
    tabPanel(
        title = "Group",
        card(
            class = "graph-card",
            card_header("Group Attendance Plot"),
            plotOutput("cumulative_graph")
        )
    )
)