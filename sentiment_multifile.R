# libraries
library(tidyverse)
library(tidytext)
library(glue)
library(stringr)
library(wordcloud)
library(tm)
library(RColorBrewer)



# now we write a function to calculate the sentiment for 
# each of our text files we would like to analyse,
# basically turn code from the single file into a 
# function

GetSentiment <- function(file){
  # get the file
  fileName <- glue(path, file, sep = "")
  
  # read in the new file
  fileText <- glue(read_file(fileName))
  # remove any dollar signs (they're special characters in R)
  fileText <- gsub("\\$", "", fileText) 
  
  # tokenize
  tokens <- data_frame(text = fileText) %>% unnest_tokens(word, text)
  
  # get the sentiment ie. number of positive and negaitive words
  sentiment <- tokens %>%
    inner_join(get_sentiments("bing")) %>% # pull out only sentimen words
    count(sentiment) %>% # count the # of positive & negative words
    spread(sentiment, n, fill = 0) # made data wide rather than narrow
  
  
  if(dim(sentiment)[2]==1){sentiment <- add_column(sentiment, negative = 0)} # if no negative, add zero column
  
  sentiment <- sentiment %>% mutate(sentiment = positive - negative) %>% #  of positive words - # of negative owrds
    mutate(file = file) %>% # add the name of our file
    mutate(year = as.numeric(str_match(file, "\\d{4}"))) %>% # add the year (\\d{4} match exactly 4 digits)
    mutate(gender = str_match(file, "(.*?)_")[2]) # add if actor or actress (get the text from filename)
  
  sentiment$negative <- sentiment$negative/nrow(tokens)
  sentiment$positive <- sentiment$positive/nrow(tokens)
  sentiment$sentiment <- sentiment$sentiment/nrow(tokens)
  # return our sentiment dataframe
  return(sentiment)
}


# get a list of the files in the input directory
path <- ".../input_path/"
files <- list.files(path)


# file to put our output in
sentiments <- data_frame()


# get the sentiments for each file in our datset
for(i in files){
  sentiments <- rbind(sentiments, GetSentiment(i))
}

path <- "/media/thomaspatrickleahy/My Passport/DSprojects/sentiment_analysis/data/oscar_speeches/actor/"
files <- list.files(path)[1:18]



####
# plot of the smoothed actor and actress sentiment over time
#

ggplot(sentiments, aes(x = as.numeric(year), y = sentiment, col=gender)) +  # add points to our plot, color-coded by president
  geom_smooth(method = "auto") +# pick a method & fit a model
  geom_point() 

####
# create a word cloud from all speeaches together, can combine all text in R
# or use a handy linux command (cat * > merged-file)

fileName <- ".../input_file/"

text <- readLines(fileName)
docs <- Corpus(VectorSource(text))  # Corpus class

# strip back text, removing common english words, numbers etc
docs <-  tm_map(docs, content_transformer(tolower)) # all text lower case
docs <- tm_map(docs, removeNumbers)    # Remove numbers
docs <-  tm_map(docs, removeWords, stopwords("english"))   # Remove english common stopwords
docs <- tm_map(docs, removePunctuation) # Remove punctuations
docs <- tm_map(docs, stripWhitespace) # Eliminate extra white spaces

doc_to_mat <- TermDocumentMatrix(docs)
mat <- as.matrix(doc_to_mat)  # create a matrix of word use
sort_freq <- sort(rowSums(mat),decreasing=TRUE)  # calculate frequency and sort 
df <- data.frame(word = names(sort_freq),freq=sort_freq) 

set.seed(2104)
wordcloud(words = df$word, freq = df$freq, min.freq = 1,   # create and plot word cloud
          max.words=40, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

