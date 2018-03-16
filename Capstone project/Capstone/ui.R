#
# Data Science Coursera Capstone project
# Word prediction

library(shiny)

# Define UI for application that predict words
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Data Science Coursera Capstone project--predicting words"),
  
  # Sidebar with a text input 
  sidebarLayout(
    sidebarPanel(
        h2("Sidebar: Please enter your word(s)"),
        h3("The predicted next word will show in Mainpanel"),
        textInput("Input","Type your word(s) here", value = "")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h2("Main panel: Your next word will be"),
      verbatimTextOutput("prediction")
    )
  )
))
