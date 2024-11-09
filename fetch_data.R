ticker <- readLines("myapp/tofetch.txt")

if (!require(quantmod)) {
  install.packages("quantmod", repos="http://cran.r-project.org")
  library(quantmod)
}
getSymbols(ticker, src = "yahoo", auto.assign = TRUE)
write.csv(get(ticker), paste0("myapp/",ticker, ".csv"))
