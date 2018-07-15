
library(shiny)
library(quantmod)
library(BatchGetSymbols)
library(tidyverse)
library(xlsx)

daily <- read_csv("trades_processed_daily.csv",
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
                   "count" = col_integer(),
                   "dn" = col_double(),
                   "mavg" = col_double(),
                   "up" = col_double(),
                   "pctB" = col_double()
                 ))

weekly <- read_csv("trades_processed_weekly.csv",
                       col_names = TRUE,
                       col_types = list(
                         "X1" = "_",
                         "ticker" = col_character(),
                         "week" = col_date(format = ""),
                         "price.open" = col_double(),
                         "price.high" = col_double(),
                         "price.low" = col_double(),
                         "price.close" = col_double(),
                         "price.typical" = col_double(),
                         "dn" = col_double(),
                         "mavg" = col_double(),
                         "up" = col_double(),
                         "pctB" = col_double()
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
    
    for (t in unique(daily$ticker)) {
        l <- daily %>% filter(ticker == t)
        if ((max(tail(l$mavg,5*3))< (1+price_fluctuation) * l$mavg[length(l$mavg)-5*3]) & (min(tail(l$mavg,5*3)) > (1-price_fluctuation) * l$mavg[length(l$mavg)-5*3])) {
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
        l <- daily %>% filter(ticker == s)
        if ((max(tail(l$price.close,time_span))*(1-price_drop_ratio) >= 
         l$price.close[length(l$mavg)-5*3])) {
            ticker_picked2 <- c(ticker_picked2,s)
      }
     }
    return(ticker_picked2)
  })
  
  filter_plot <- reactive({
    if (input$data == "daily") {
      ticker <- daily %>% filter(ticker == input$symbol) %>%
                       mutate(date = as.Date(as.character(ref.date))) %>%
                       filter(date >= input$daterange[1] & date <= input$daterange[2]) %>%
        select(ref.date:price.close)
    }
    else if (input$data == "weekly") {
      ticker <- weekly %>% filter(ticker == input$symbol) %>%
        mutate(date = as.Date(as.character(week))) %>%
        filter(date >= input$daterange[1] & date <= input$daterange[2]) %>%
        select(week:price.close)
    }
    
  })
  
  ticker_info <- reactive({
    info <- all_stock_info %>%
            filter(Symbol == input$symbol)
  })
  
  observeEvent(input$update,{
    showNotification(
      "Please wait while calculation is on-going.",
      duration = 10,
      closeButton = TRUE,
      type = "message",
      session = getDefaultReactiveDomain()
    )
  })
  
  output$view <- renderTable({
    
    # show the picked stock symols
    matrix(filter_two(),ncol = 10, byrow = TRUE)
    
  })
  
  output$ticker <- renderTable({
    # show the stock symbol informatoin
    ticker_info()
  })
  
  output$Bplot <- renderPlot({
    # show the financial plot
    ticker_plot <- filter_plot()
    
    if (input$data == "daily") {
      ticker_xts <- xts(ticker_plot[,2:5],
                      order.by = as.Date(as.character(ticker_plot$ref.date)))
    }
    else if (input$data == "weekly") {
      ticker_xts <- xts(ticker_plot[,2:5],
                      order.by = as.Date(as.character(ticker_plot$week)))
    }  
    candleChart(ticker_xts)
    addBBands()
  })
  
})
