library(shiny)
library(quantmod)

ui <- fluidPage(
  titlePanel("Stock Data Fetcher"),
  sidebarLayout(
    sidebarPanel(
      textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
      actionButton("fetch", "Fetch Data")
    ),
    mainPanel(
      tableOutput("stock_data")
    )
  )
)

server <- function(input, output) {
  stock_data <- eventReactive(input$fetch, {
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
}

shinyApp(ui = ui, server = server)
