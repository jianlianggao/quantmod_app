#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
#library(quantmod)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Stock Price"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          textInput("ticker", "Enter Stock Ticker Symbol:", value = "AAPL"),
          # dateRangeInput("dateRange", "Select Date Range:",
          #                start = Sys.Date() - 30, end = Sys.Date()),
          #actionButton("goButton", "Go")
          #verbatimTextOutput("result")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           #plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # stockData <- eventReactive(input$goButton, {
  #   getSymbols(input$ticker, src = "yahoo", 
  #              # from = input$dateRange[1], to = input$dateRange[2], 
  #              auto.assign = FALSE)
  # })

    # output$distPlot <- renderPlot({
    #    data <- stockData()
    #    chartSeries(data, name = paste(input$ticker, "Price") )
    #    addBBands()
    # })
  
  # Trigger initial rendering
  observe({
    updateTextInput(session, "ticker", value = "AAPL")
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
