library(shiny)


ui <- fluidPage(
  titlePanel("Stock Data Fetcher"),
  sidebarLayout(
    sidebarPanel(
      textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
      actionButton("fetch", "Fetch Data")
    ),
    mainPanel(
      textOutput("message"),
      tableOutput("stock_data")
    )
  )
)

server <- function(input, output, session) {
  output$message <- renderText(
    paste("This is test of display", input$ticker)
  )
  
  stock_data <- eventReactive(input$fetch, {
    if (!require(quantmod)) {
      install.packages("quantmod", repos="http://cran.r-project.org")
      library(quantmod)
    }
    req(input$ticker)
    tryCatch({
      getSymbols(input$ticker, src = "yahoo", auto.assign = FALSE)
    }, error = function(e) {
      NULL
    })
  })
  
  output$stock_data <- renderTable({
    data <- stock_data()
    if (is.null(data)) {
      return(data.frame(Message = "Invalid ticker symbol or data not available."))
    }
    head(data)
  })
  # Trigger initial rendering
  observe({
    updateTextInput(session, "ticker", value = "AAPL")
    
  })
}

shinyApp(ui = ui, server = server)
