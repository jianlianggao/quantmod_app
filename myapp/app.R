library(shiny)
library(plotly)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .plotly {
        width: 100% !important;
      }
    "))
  ),
  textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
  actionButton("submit", "Submit"),
  plotlyOutput("combinedPlot", width = "100%")
)

server <- function(input, output, session) {
  stockData <- eventReactive(input$submit, {
    ticker <- input$ticker
    data <- read.csv(paste0("../data/", ticker, ".csv"))
    data$Date <- as.Date(data$Date)
    data
  })
  
  output$combinedPlot <- renderPlotly({
    data <- stockData()
    ticker <- input$ticker
    
    # Create the candlestick plot
    candlestick <- plot_ly(data, x = ~Date, type = "candlestick",
                           open = ~data[[paste0(ticker, ".Open")]], 
                           high = ~data[[paste0(ticker, ".High")]], 
                           low = ~data[[paste0(ticker, ".Low")]], 
                           close = ~data[[paste0(ticker, ".Close")]],
                           name = "Candlestick")
    
    # Create the volume plot
    volume <- plot_ly(data, x = ~Date, y = ~data[[paste0(ticker, ".Volume")]], type = 'bar', name = 'Volume', yaxis = "y2")
    
    # Combine the plots
    subplot(candlestick, volume, nrows = 2, shareX = TRUE) %>%
      layout(title = paste("Candlestick and Volume Chart for", ticker),
             yaxis = list(title = "Price"),
             yaxis2 = list(title = "Volume", overlaying = "y", side = "right"))
  })
}

shinyApp(ui, server)
