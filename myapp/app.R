library(shiny)
library(ggplot2)
library(httr)

ui <- fluidPage(
  titlePanel("Stock Data Fetcher"),
  sidebarLayout(
    sidebarPanel(
      textInput("ticker", "Enter Ticker Symbol:", value = "AAPL"),
      actionButton("trigger", "Fetch Data")
    ),
    mainPanel(
      plotOutput("stock_plot"),
      textOutput("status")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$trigger, {
    req(input$ticker)
    token <- Sys.getenv("GITHUB_TOKEN")
    POST(
      url = "https://api.github.com/repos/yourusername/yourrepo/actions/workflows/deploy.yml/workflow_dispatch",
      add_headers(Authorization = paste("token", token)),
      body = list(ref = "main", inputs = list(ticker = input$ticker)),
      encode = "json"
    )
    output$status <- renderText("Fetching data...")
  })
  
  observe({
    invalidateLater(10000, session)  # Check every 10 seconds
    ticker <- input$ticker
    if (file.exists(paste0(ticker, ".csv"))) {
      data <- read.csv(paste0(ticker, ".csv"))
      output$stock_plot <- renderPlot({
        ggplot(data, aes(x = index(data), y = data[, 4])) +  # Adjust column index as needed
          geom_line() +
          labs(title = paste("Stock Price for", ticker), x = "Date", y = "Price")
      })
      output$status <- renderText("Data loaded successfully!")
    }
  })
}

shinyApp(ui = ui, server = server)
