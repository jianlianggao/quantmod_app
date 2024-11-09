library(shiny)
library(xts)
library(quantmod)

ui <- fluidPage(
  textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
  actionButton("submit", "Submit"),
  plotOutput("stockPlot")
)

server <- function(input, output, session) {
  # Use eventReactive to trigger data loading when the submit button is clicked
  stockData <- eventReactive(input$submit, {
    ticker <- input$ticker
    data <- read.csv(paste0("../data/", ticker, ".csv"))
    data$Date <- as.Date(data$Date)
    xts(data[, -1], order.by = data$Date)
  })
  
  output$stockPlot <- renderPlot({
    data <- stockData()
    chartSeries(data, name = input$ticker)
  })
}

shinyApp(ui, server)
