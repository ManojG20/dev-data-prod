library(shiny)



shinyUI(fluidPage(
    titlePanel("Twitter Analysis"),
    sidebarLayout(
        sidebarPanel("Twitter Selections",
            selectInput("var",
                        label="Choose hashtag to search Twitter",
                        choices=c("#DataScience", "#MachineLearning", "#Statistics"),
                        selected = "#DataScience"),
            
            sliderInput("tweets", 
                        label="Select Number of Tweets",
                        min=10, max=50, value=15)
        ),
        mainPanel(
            HTML("<div>
                    <h3>User Guide</h3>
                    <p> This is a simple application, to download some tweets from twitter
and plot a word cloud based on the words in the downloaded tweets. Following are the steps</p>
                    <p> 1. Select the hashtag to search from the drop down</p>
                    <p> 2. Select the Number of tweets to download from the slider</p>
                    <p> 3. This app will download recent tweets with tha selected hashtag and selected count </p>
                    <p> 4. After downloading, clean the tweets and extract creates a term-document matrix.</p>
                    <p> 5. Plots a word cloud below</p>
                 </div><br>
                 <div><h3>Word Cloud</h3></div>"),
            plotOutput("wordCloud")
        )
    )

))