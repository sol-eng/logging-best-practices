# a simple, interactive logging demo

library(shiny)
library(shinythemes)
library(rlog)

# Startup

log_level <- Sys.getenv("LOG_LEVEL", "INFO")

clear_console_button <- if (Sys.getenv("RSTUDIO") == 1){
  fluidRow(
    column(6,
           hr(),
           actionButton("clear_console", "Make space in the console"),
           align = "center",
           offset = 3)
  )
}

# Define UI for application
ui <- fluidPage(
  theme = shinytheme("superhero"),
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    column(6,
  titlePanel("Interactive logging demo"),
  offset = 3)
  ),
  fluidRow(
    column(6,
    p("This demo application uses the", a("rlog", href = "https://rlog.sellorm.com"),
      "package (", a("CRAN", href='https://cran.r-project.org/package=rlog'), ") to ",
      "write simple log messages while the app runs."),
    p("In this example, log events are triggered by the buttons below.", 
      "In a real application anything could trigger a log event, ", 
      "but they're best tied to the various activities your app performs."),
    offset = 3)
  ),
  fluidRow(
    column(6,
           hr(),
           p("For the purposes of this demo, we can control the LOG_LEVEL inside the app."),
           p(strong("Note: In practice the LOG_LEVEL should always be set using",
                    "an environment variable that is external to your app.")),
           p("Log levels, in descending order or priority:"),
           radioButtons("app_log_level",
                       "",
                       c("FATAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"),
                       selected = "INFO"),
           p("Choose one of the options above to change the current LOG_LEVEL"),
           p("The `LOG_LEVEL` environment variable controls what log messages will be emitted."),
           p("Only messages at the current LOG_LEVEL or higher will be emitted."),
           p("Try changing the LOG_LEVEL environment variable for this app and ",
             "see which messages are output into the console or the RStudio Connect ",
             "'Logs' tab for this application."),
    offset = 3)
  ),
  
  # Buttons
  
  fluidRow(
    column(6,
           hr(),
           p("Use the buttons below to try to output log messages at the various log levels."),
           offset = 3)
  ),
  fluidRow(
    column(2,
           actionButton("log_fatal", "FATAL"),
           align = "center",
           offset = 3),
    column(2,
           actionButton("log_error", "ERROR"),
           align = "center"
    ),
    column(2,
           actionButton("log_warn", "WARN"),
           align = "center"
  ),
  ),
  fluidRow(HTML('&nbsp;')),
  fluidRow(
    column(2,
           actionButton("log_info", "INFO"),
           align = "center",
           offset = 3),
    column(2,
           actionButton("log_debug", "DEBUG"),
           align = "center"
    ),
    column(2,
           actionButton("log_trace", "TRACE"),
           align = "center"
    ),
           
  ),
  fluidRow(
    column(6,
           hr(),
           p("Since, you'll hopefully never write an application that requires users",
             "to explicity press a button to get a log message, it's important to",
             "understand what a 'real' scenario might look like."),
           p("This last button simulates what a real app might do by attempting",
             "to emit two messages at each log level."),
           p("As with all logging, only log messages at the current",
             "log level or higher will actually be emitted."),
           actionButton("all_logs", "Emit with all log message levels"),
           offset = 3)
  ),
  clear_console_button,
  # More info
  fluidRow(
    column(6,
           hr(),
        p("For more information about logging with the rlog package, please",
        a("visit it's website", href="https://rlog.sellorm.com"), "."),
           offset = 3)
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  observeEvent(input$log_fatal, {
    if (rlog::log_fatal("This is your fatal message")){
      message <- "Your FATAL message was emitted"
    } else {
      message <- "Your FATAL message was not emitted"
    }
    session$sendCustomMessage(type = 'logmessage', message = message)
    cat("\n\n")
  })

  observeEvent(input$log_error, {
    if (rlog::log_error("This is your error message")){
      message <- "Your ERROR message was emitted"
    } else {
      message <- "Your ERROR message was not emitted"
    }
    session$sendCustomMessage(type = 'logmessage', message = message)
    cat("\n\n")
  })

  observeEvent(input$log_warn, {
    if (rlog::log_warn("This is your warning message")){
      message <- "Your WARN message was emitted"
    } else {
      message <- "Your WARN message was not emitted"
    }
    session$sendCustomMessage(type = 'logmessage', message = message)
    cat("\n\n")
  })

  observeEvent(input$log_info, {
    if (rlog::log_info("This is your info message")){
      message <- "Your INFO message was emitted"
    } else {
      message <- "Your INFO message was not emitted"
    }
    session$sendCustomMessage(type = 'logmessage', message = message)
    cat("\n\n")
  })

  observeEvent(input$log_debug, {
    if (rlog::log_debug("This is your debug message")){
      message <- "Your DEBUG message was emitted"
    } else {
      message <- "Your DEBUG message was not emitted"
    }
    session$sendCustomMessage(type = 'logmessage', message = message)
    cat("\n\n")
  })

  observeEvent(input$log_trace, {
    if (rlog::log_trace("This is your trace message")){
      message <- "Your TRACE message was emitted"
    } else {
      message <- "Your TRACE message was not emitted"
    }
    session$sendCustomMessage(type = 'logmessage', message = message)
    cat("\n\n")
  })

  observeEvent(input$all_logs, {
    rlog::log_trace("My app emits this trace message")
    rlog::log_debug("My app emits this debug message")
    rlog::log_info("My app emits this info message")
    rlog::log_warn("My app emits this warning message")
    rlog::log_error("My app emits this error message")
    rlog::log_fatal("My app emits this fatal message")
    rlog::log_trace("My app emits this trace message")
    rlog::log_debug("My app emits this debug message")
    rlog::log_info("My app emits this info message")
    rlog::log_warn("My app emits this warning message")
    rlog::log_error("My app emits this error message")
    rlog::log_fatal("My app emits this fatal message")
    cat("\n\n")
    session$sendCustomMessage(
      type = 'logmessage',
      message = "You clicked to run the larger example - check the console or Connect's 'Log' tab")
  })
  observeEvent(input$app_log_level, {
    rlog::log_info(paste("Switching LOG_LEVEL to:", input$app_log_level))
    cat("\n\n")
    Sys.setenv("LOG_LEVEL" = input$app_log_level)
  })
  observeEvent(input$clear_console, {
    cat("\n\n\n\n\n---------------------\n\n\n\n\n")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
