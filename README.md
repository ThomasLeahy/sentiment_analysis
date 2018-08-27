# sentiment_analysis


Sentiment analysis is a form of data mining. In particular, it mines text and aims at extracting
information about the text, namely the sentiment. An example would be to analyse the tweets
during a political campaign, to understand the sentiment towards a candidate for example.

Here we provide some basic R code using typical packages for sentiment analysis and data as an
example application.

There are different types of sentiment, simply positive or negative (polarity), or ranked sentiment 
on scale. More advanced versions maybe to happy, sad, angry, etc. sentiment.

To compare the words in a text to see if they are positive or negative we compare them against a
lexicon. Which is like a big dictionary with sentiments attached. One can use a predefined lexicon
(as in our example) or create ones own. A specific type of lexicon maybe required depending on 
the context. For example, if one is analysing Justin Bieber's tweets, "sick" might be used in 
a positive sense rather than a negative sense that it would be typically categorised as.

We show how to analyse a single text and then we extend to multiple texts. With some added plotting
and a wordcloud of the most frequency used words. 

The data we use is the winners speeches from the leading actor and actress categories at the Oscar's
from 2000 to 2017.