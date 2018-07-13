
library(shiny)
library(quantmod)
library(BatchGetSymbols)
library(tidyverse)
library(xlsx)

data <- read_csv("trades_processed_boll.csv",
                 col_names = TRUE,
                 col_types = list(
                    "X1" = "_",
                    "ticker" = col_character(),
                    "ref.date" = col_date(format = ""),
                    "price.open" = col_double(),
                    "price.high" = col_double(),
                    "price.low" = col_double(),
                    "price.close" = col_double(),
                    "price.typical" = col_double(),
                    "BBands" = col_double(),
                    "Bdn" = col_double(),
                    "Bup" = col_double(),
                    "pctB" = col_double(),
                    "Width" = col_double() 
                 ))

all_stock_info <- read_csv("all_stock_info.csv", 
                           col_names = TRUE,
                           col_types = list(
                             "X1" = "_",
                             "Symbol" = col_character(),
                             "Name" = col_character(),
                             "LastSale" = col_double(),
                             "MarketCap" = col_character(),
                             "IPOyear" = col_integer(),
                             "Sector" = col_character(),
                             "Industry" = col_character(),
                             "Exchange" = col_character()
                           ))

# Define server logic required to display the table
shinyServer(function(input, output) {
  
  # Filter only the ones that fluctuate smaller than 5%
  filter_one <- eventReactive(input$update,{
    price_fluctuation <- input$price_fluctuation
    ticker_picked <- c()
    
    for (t in unique(data$ticker)) {
        l <- data %>% filter(ticker == t)
        if ((max(tail(l$BBands,5*3))< (1+price_fluctuation) * l$BBands[length(l$BBands)-5*3]) & (min(tail(l$BBands,5*3)) > (1-price_fluctuation) * l$BBands[length(l$BBands)-5*3])) {
            ticker_picked <- c(ticker_picked,t)
      }
    }
    return(ticker_picked)
  })
  
  # Get symbols that have price drops before the flat region
  filter_two <- eventReactive(input$update, {
    price_drop_ratio <- input$price_drop_ratio
    time_span <- input$time_span
    ticker_picked2 <- c()
    for (s in filter_one()) {
        l <- data %>% filter(ticker == s)
        if ((max(tail(l$price.close,time_span))*(1-price_drop_ratio) >= 
         l$price.close[length(l$BBands)-5*3])) {
            ticker_picked2 <- c(ticker_picked2,s)
      }
    }
    return(ticker_picked2)
  })
  
  filter_plot <- reactive({
    ticker <- data %>% filter(ticker == input$symbol) %>%
                       mutate(date = as.Date(as.character(ref.date))) %>%
                       filter(date >= input$daterange[1] & date <= input$daterange[2]) %>%
                       select(ref.date:price.close)
    
  })
  
  output$view <- renderTable({
    
    # show the picked stock symols
    matrix(filter_two(),ncol = 10, byrow = TRUE)
    
  })
  
  output$ticker <- renderTable({
    # show the stock symbol informatoin
    info <- all_stock_info %>%
            filter(Symbol == input$symbol)
  })
  
  output$Bplot <- renderPlot({
    # show the financial plot
    ticker_plot <- filter_plot()
    ticker_xts <- xts(ticker_plot[,2:5],
                      order.by = as.Date(as.character(ticker_plot$ref.date)))
    candleChart(ticker_xts)
    addBBands()
  })
  
})
