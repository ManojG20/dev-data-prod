library(twitteR)
library(ROAuth)
library(RCurl)
library(tm)
library(wordcloud)
library(shiny)

load("twitteR_credentials")
registerTwitterOAuth(twitCred)

shinyServer(function(input, output) {
    
    twtList <- function(searchTerm, tweets){
        twt <- searchTwitter(searchTerm, n = tweets)
        
        at <- sapply(twt, function(x) x$getText())
        
        at1 <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", at)
        
        #Remove @people
        at2 <- gsub("@\\w+", "", at1)
        
        #Remove Punctuations
        at3 <- gsub("[[:punct:]]", "", at2)
        
        #Remove Digits
        at4 <- gsub("[[:digit:]]", "", at3)
        
        #Remove HTML Links
        at5 <- gsub("http\\w+", "", at4)
        
        #Remove White spaces
        at6 <- gsub("[ \t]{2,}", "", at5)
        at7 <- gsub("^\\s+|\\s+$", "", at6)
        
        
        at_corpus = Corpus(VectorSource(at7))
        
        at_tdm = TermDocumentMatrix(
            at_corpus,
            control = list(
                removePunctuation = TRUE,
                stopwords = c(stopwords("english")),
                removeNumbers = TRUE, tolower = TRUE)
        )
        
        at_matrix <- as.matrix(at_tdm)
        word_freqs <- sort(rowSums(at_matrix), decreasing = TRUE) 
        
        dm <- data.frame(word <- names(word_freqs), freq <- word_freqs)
        return(dm)
    }
    
    dm <- reactive({
        dm <- twtList(input$var, as.numeric(input$tweets))
    })
    
    output$wordCloud <- renderPlot({
        wordcloud(dm()$word, dm()$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
    })
})