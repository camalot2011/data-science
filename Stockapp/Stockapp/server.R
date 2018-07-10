#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)
library(BatchGetSymbols)
library(tidyverse)
library(xlsx)

  
# Define server logic required to display the table
shinyServer(function(input, output) {
  
  #Calculate BBands and select the ones fluctuate larger than 5%

  reactiveA <- eventReactive(input$update,{
  for (i in ticker_processed) {
      ticker_processed <- unique(trades_processed$ticker)
      ticker_boll <- data.frame()
      ticker_picked <- c()
      l <- trades_processed %>% filter(ticker == i)
      if (count(l)<62) next
      else {
          Boll <- BBands(l$price.typical,n=20,SMA,sd=2)
          l_boll <- l %>% mutate(BBands = Boll[,2],Bdn = Boll[,1], Bup = Boll[,3]) %>%
                          select(ticker,BBands, Bdn, Bup)
          ticker_boll <- rbind(ticker_boll,l_boll)
          if ((max(l_boll$BBands[47:62])< (1+input$price_fluctuation)*l_boll$BBands[47]) & 
              (min(l_boll$BBands[47:62]) > (1-input$price_fluctuation)*l_boll$BBands[47])) {
                ticker_picked <- c(ticker_picked,i)
      }
    }
  }
  
  trades_processed_boll <- filter(trades_processed, trades_processed$ticker %in% ticker_picked)
  ticker_boll_picked <- filter(ticker_boll,ticker_boll$ticker %in% ticker_picked)
  trades_picked <- mutate(trades_processed_boll, BBands = ticker_boll_picked$BBands, 
                          Bdn = ticker_boll_picked$Bdn, Bup = ticker_boll_picked$Bup)
  })
  
  reactiveB <- eventReactive(input$update,{
  
  date_gap <- 1
  ticker_picked2 <- c()
  for (s in ticker_picked) {
    l <- trades_picked %>% filter(ticker == s)
    if ((max(l$price.close[20:47])*(1-input$price_drop_ratio) >= l$price.close[47]) &
        ((l[47,2] - l[which.max(l$price.close[20:47]), 2]) > date_gap)) {
      ticker_picked2 <- c(ticker_picked2,s)
    }
  }
  }) 
  
  output$view <- renderTable({
    
    # show the picked stock symols
    ticker_picked2
    
  })
  
})
