ticker <- readLines("myapp/tofetch.txt")
library(quantmod)
getSymbols(ticker, src = "yahoo", auto.assign = TRUE)
write.csv(get(ticker), paste0("myapp/",ticker, ".csv"))
