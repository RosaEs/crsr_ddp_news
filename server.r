################################################################################
# Author: Benjamin Greve
# Date: 20.09.2014
################################################################################

#install.packages("tm")
library(XML)
library(RCurl)
library(ggplot2)


# Get the news headlines from RSS feeds at reuters.com.
# This will run only once (or on site refresh).
getNews <- function(searchterm="test") {
  # Form query
  qry <- paste0("http://api.feedzilla.com/v1/articles/search.atom?q=", searchterm)
  # Download and parse search results
  articlesXml <- xmlTreeParse(getURL(qry), useInternalNodes=TRUE)
  # Store results in a data frame
  articles <- data.frame(
    Title = sapply(xpathSApply(articlesXml, path="//a:feed/a:entry/a:title", namespaces=c(a="http://www.w3.org/2005/Atom")), xmlValue),
    Source = sapply(xpathSApply(articlesXml, path="//a:feed/a:entry/a:source/a:title", namespaces=c(a="http://www.w3.org/2005/Atom")), xmlValue),
    Link = xpathSApply(articlesXml, path="//a:feed/a:entry/a:source/a:link/@href", namespaces=c(a="http://www.w3.org/2005/Atom")),
    stringsAsFactors = FALSE
  )
  # Make links functional
  articles$Link <- paste0("<a href=\"", articles$Link, "\">LINK</a>")
  return(articles)
}


# Run getter function once
getNews()


getSources <- function(x) {
  tab <- table(x)
  src <- as.data.frame(tab)
  names(src) <- c("Source", "Articles")
  src <- src[order(src$Articles, decreasing=TRUE),]
  return(src)
}


shinyServer(
  function(input, output) {
    # Get news headlines
    articles <- reactive({getNews(input$st)})
    
    # Output
    # Search term
    output$oSt <- renderPrint({input$st})
    #Sources
    output$oSrc <- renderTable(getSources(articles()$Source))
    
    # List of headlines with links
    output$oHeadlineList <- renderTable(articles(), sanitize.text.function = function(x) x)
  }
)






