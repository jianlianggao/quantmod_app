library(shiny)
library(xts)

ui <- fluidPage(
  textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
  actionButton("submit", "Submit"),
  plotOutput("stockPlot")
)

server <- function(input, output, session) {
  observeEvent(input$submit, {
    ticker <- input$ticker
    data <- read.csv(paste0("../data/",ticker,".csv"))
    data$Date <- as.Date(data$Date)
    data <- xts(data[, -1], order.by = data$Date)
  })
  
  output$stockPlot <- renderPlot({
    library(quantmod)
    
    chartSeries(data, name = ticker)
  })
}

shinyApp(ui, server)
