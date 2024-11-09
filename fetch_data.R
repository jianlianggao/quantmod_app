tickers <- read.csv("tofetch.txt")

if (!require(quantmod)) {
  install.packages("quantmod", repos="http://cran.r-project.org", dependencies = TRUE)
  library(quantmod)
}

for (ticker in tickers$Symbol) {
  
  tryCatch(
        {
            # Just to highlight: if you want to use more than one
            # R expression in the "try" part then you'll have to
            # use curly brackets.
            # 'tryCatch()' will return the last evaluated expression
            # in case the "try" part was completed successfully

            data <- getSymbols(ticker, auto.assign = F)

            # Convert the xts object to a data frame and include the date
            data <- data.frame(Date = index(data), coredata(data))
            
            # Save the data frame to a CSV file
            write.csv(data, file = paste0("data/", ticker, ".csv"), row.names = FALSE)
            # The return value of `readLines()` is the actual value
            # that will be returned in case there is no condition
            # (e.g. warning or error).
        },
        error = function(cond) {
            #message(paste(ticker, " does not seem to exist on Yahoo ==========="))
        },
        
        finally = {
            # NOTE:
            # Here goes everything that should be executed at the end,
            # regardless of success or error.
            # If you want more than one expression to be executed, then you
            # need to wrap them in curly brackets ({...}); otherwise you could
            # just have written 'finally = <expression>' 
           #message(paste("Processed ticker:", ticker))
          
        }
    )
  
  
  
}
