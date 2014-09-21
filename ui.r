################################################################################
# Author: Benjamin Greve
# Date: 20.09.2014
################################################################################

library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel("Query Feedzilla news feed"),
    sidebarPanel(
      h3("About"),
      p("Project for the Developing Data Products course in Coursera's Data Science specialization."),
      h3("Usage"),
      p("Enter a search term to query the Feedzilla news feed."),
      h3("Input"),
      textInput("st", "Search Term", "europe"),
      submitButton("Execute")
    ),
    mainPanel(
      p("You're searching for"),
      verbatimTextOutput("oSt"),
      
      h3("News Sources"),
      p("The following news sources have published articles related to your search term"),
      tableOutput("oSrc"),
      
      h3("Headlines"),
      tableOutput("oHeadlineList")
    )
  )
)

