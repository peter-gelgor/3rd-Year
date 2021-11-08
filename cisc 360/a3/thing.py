import nltk

#analyse sentiment from text
def getSentiment(text):
    #import libraries
    
    from nltk.sentiment.vader import SentimentIntensityAnalyzer
    #analyse sentiment
    sid = SentimentIntensityAnalyzer()
    sentiment = sid.polarity_scores(text)
    return sentiment

print(getSentiment("My dog just died"))