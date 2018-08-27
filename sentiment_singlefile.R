# libraries
library(tidyverse)
library(tidytext)
library(glue)
library(stringr)


# get a list of the files in the input directory
path <- ".../input_path/"
files <- list.files(path)


# look at the first file and tokenise
# stick together the path to the file & 1st file name
fileName <- glue(path, files[1], sep = "")


# read in the file in which to analyse
fileText <- glue(read_file(fileName))


# remove any dollar signs since these are special characters in R
fileText <- gsub("\\$", "", fileText) 

# we will use the %>% (chaining) operation
# basically takes the output of a fuction 
# and feeds it into the next function
# rather than messy nested parentheses

# tokenize
tokens <- data_frame(text = fileText) %>% unnest_tokens(word, text) #creates the tokens


sentiment<- tokens %>%
  inner_join(get_sentiments("bing")) %>% # pull out only sentiment words compared to bing lexicon
  count(sentiment) %>% # count the number of positive & negative words
  spread(sentiment, n, fill = 0) # transpose dataframe

# For the data we are considering namely
# oscar acceptance speeches, there is in
# general mostly positive sentiment. In some
# cases there maybe no negative sentiment
# at all, so in this case we add a 0 
# negative column

if(dim(sentiment)[2]==1){sentiment <- add_column(sentiment, negative = 0)}

sentiment <- sentiment %>% mutate(sentiment = positive - negative)  # add a column with difference between positive and negative
sentiment <- sentiment/nrow(tokens)  # normalise for text length (important when comparing between texts)
