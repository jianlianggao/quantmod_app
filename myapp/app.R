library(shiny)


ui <- fluidPage(
  textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
  actionButton("submit", "Submit"),
  plotOutput("stockPlot")
)

server <- function(input, output, session) {
  observeEvent(input$submit, {
    ticker <- input$ticker
    writeLines(ticker, "tofetch.txt")
    system("git add myapp/tofetch.txt")
    system("git commit -m 'Update tofetch.txt'")
    system("git push -f")  
  })
  
  output$stockPlot <- renderPlot({
    library(quantmod)
    invalidateLater(60000, session)  # Refresh every minute
    ticker <- input$ticker
    data <- read.csv(paste0( ticker, ".csv"))
    chartSeries(as.xts(data[, -1], order.by = as.Date(data[, 1])), name = ticker)
  })
}

shinyApp(ui, server)
