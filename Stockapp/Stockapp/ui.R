#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that return picked stock symbols
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Stock picking App"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       # Input the price-fluctuation range between 0 and 1 with default at 0.05
       numericInput(inputId = "price_fluctuation",
                    label = "Please set price fluctuation range (0.00-1.00):",
                    min = 0,
                    max = 1,
                    step = 0.01,
                    value = 0.05),
       # Input the price drop ratio between 0 and 1 with default at 0.1
       numericInput(inputId = "price_drop_ratio",
                    label = "Please set price drop ratio (0.00-1.00)",
                    min = 0,
                    max = 1,
                    step = 0.01, 
                    value = 0.1),
       # Put up an action button
       actionButton(inputId = "update",
                    label = "Update View")
       
    ),
    # Show a table with the picked stock symbols
    mainPanel(
       
       h3("Stock picked:"),
       tableOutput("view")
    )
  )
))
