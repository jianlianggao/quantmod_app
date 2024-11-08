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
          dateRangeInput("dateRange", "Select Date Range:",
                          start = Sys.Date() - 30, end = Sys.Date()),
          actionButton("goButton", "Go")
          #verbatimTextOutput("result")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           #plotOutput("distPlot")
          fluidRow(
            column(6, plotOutput("distPlot"))
          ),
          fluidRow(
            column(12, tableOutput("stock_data"))
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  library(quantmod)
  library(knitr)
  output$message <- renderText({
    data <- getSymbols(input$ticker, src = "yahoo",
                       from = input$dateRange[1], to = input$dateRange[2],
                       auto.assign = FALSE)
    kable(head(data), caption = paste(input$ticker, "preview"))
  })
  stockData <- eventReactive(input$goButton, {
    
    getSymbols(input$ticker, src = "yahoo",
                from = input$dateRange[1], to = input$dateRange[2],
                auto.assign = FALSE)
   })
  
  output$stock_data <- renderTable({
    data <- stockData()
    if (is.null(data)) {
      return(data.frame(Message = "Invalid ticker symbol or data not available."))
    }
    head(data)
  })

     output$distPlot <- renderPlot({
       
        data <- stockData()
        # Pre-fetch data and save as CSV
      
        write.csv(data, "data.csv")
        
        #req(data)
        chartSeries(data, name = paste(input$ticker, "Price") )
        addBBands()
     })
  
  # Trigger initial rendering
  observe({
    updateTextInput(session, "ticker", value = "AAPL")
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
