library(shiny)
library(plotly)
library(dplyr)

# initial data for plotly
data=read.csv("../data/AAPL.csv", stringsAsFactors = F)


# Define UI
ui <- fluidPage(
  titlePanel("Stock Price"),
  sidebarLayout(
    sidebarPanel(
      textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
      actionButton("submit", "Submit")
      #textInput("research", "Your research:"),
      #actionButton("calculate", "Calculate Similarity"),
      #verbatimTextOutput("result")
    ),
    mainPanel(
      plotlyOutput("combinedPlot")
      
    )
  )
)


server <- function(input, output, session) {
  stockData <- eventReactive(input$submit, {
    ticker <- input$ticker
    read.csv(paste0("../data/", ticker, ".csv"))
    #data <- data %>% data.frame()
    #print(head(data))
    #data$Date <- as.Date(data$Date)
    #print(head(data))
  })
  
  output$combinedPlot <- renderPlotly({
    data <- as.data.frame(stockData())
    req(data)
    data$Date <- as.Date(data$Date)
    ticker <- input$ticker
    #data <- data %>% data.frame()
    #print(head(data))
    
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
    # Trigger initial rendering
    observe({
      updateTextInput(session, "ticker", value = "")
    })

}

shinyApp(ui, server)
