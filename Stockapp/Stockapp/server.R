#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  library(quantmod)
  library(BatchGetSymbols)
  library(tidyverse)
  library(xlsx)
  
  # Getting the symbols for all the stocks
  all_stock_info <- stockSymbols(exchange = c("AMEX","NASDAQ","NYSE"),
                                 sort.by = c("Exchange","Symbol"),quiet = FALSE)
  tickers <- all_stock_info$Symbol
  # Download from Yahoo finance
  start <- Sys.Date() - 90
  end <- Sys.Date()
  trades <- BatchGetSymbols(tickers = tickers,first.date = start, last.date = end, 
                            thresh.bad.data = 0.75,bench.ticker = "QQQ",do.complete.data = TRUE,
                            do.cache = TRUE,cache.folder = "~/BGS_Cache")
  
  trades_processed <- trades$df.tickers %>% filter(price.adjusted > 0.5 & price.adjusted < 15) %>%
    select(ticker,ref.date,price.high:price.close) %>%
    mutate(price.typical = (price.high+price.low+price.close)/3)
  #Calculate BBands and select the ones fluctuate larger than 5%
  ticker_processed <- unique(trades_processed$ticker)
  ticker_boll <- data.frame()
  ticker_picked <- c()
  price_fluctuation <- input$price_fluctuation
  for (i in ticker_processed) {
    l <- trades_processed %>% filter(ticker == i)
    if (count(l)<62) next
    else {
      Boll <- BBands(l$price.typical,n=20,SMA,sd=2)
      l_boll <- l %>% mutate(BBands = Boll[,2],Bdn = Boll[,1], Bup = Boll[,3]) %>%
        select(ticker,BBands, Bdn, Bup)
      ticker_boll <- rbind(ticker_boll,l_boll)
      if ((max(l_boll$BBands[47:62])< (1+price_fluctuation)*l_boll$BBands[47]) & (min(l_boll$BBands[47:62]) > (1-price_fluctuation)*l_boll$BBands[47])) {
        ticker_picked <- c(ticker_picked,i)
      }
    }
  }
  
  trades_processed_boll <- filter(trades_processed, trades_processed$ticker %in% ticker_picked)
  ticker_boll_picked <- filter(ticker_boll,ticker_boll$ticker %in% ticker_picked)
  trades_picked <- mutate(trades_processed_boll, BBands = ticker_boll_picked$BBands, 
                          Bdn = ticker_boll_picked$Bdn, Bup = ticker_boll_picked$Bup)
  price_drop_ratio <- input$price_drop_ratio
  date_gap <- 1
  ticker_picked2 <- c()
  for (s in ticker_picked) {
    l <- trades_picked %>% filter(ticker == s)
    if ((max(l$price.close[20:47])*(1-price_drop_ratio) >= l$price.close[47]) &
        ((l[47,2] - l[which.max(l$price.close[20:47]), 2]) > date_gap)) {
      ticker_picked2 <- c(ticker_picked2,s)
    }
  }
  
  ticker_picked <- matrix(ticker_picked,ncol = 10, byrow = TRUE)
  ticker_picked2 <- matrix(ticker_picked2,ncol = 10, byrow = TRUE) 
  
  output$view <- renderTable({
    
    # show the picked stock symols
    ticker_picked2
    
  })
  
})
