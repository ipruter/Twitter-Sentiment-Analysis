library(twitteR)
library(ROAuth)
library(tidyverse)
library(text2vec)
library(caret)
library(glmnet)
library(ggrepel)

# converts each text element from Twitters latin1 font to ASCII
convert_syntax <- function(x) iconv(x, "latin1", "ASCII", "")
# reads an excel file of tweets and metadata and establishes columns
tweets <- read_csv('training.1600000.processed.noemoticon.csv', c('sentiment', 'id', 'date', 'query', 'user', 'text')) %>%
 # converts the sentiment metric from class to binary by checking for zero and converting all other values to 1
dmap_at('text', convert_syntax) %>% mutate(sentiment = ifelse(sentiment == 0, 0, 1))

# generates a list of random values
set.seed(123)
# creates a partition of training and testing data
data_partition <- createDataPartition(tweets$sentiment, p = 0.8, list = FALSE, times = 1)
# defines training data
training_data <- tweets[data_partition, ]
# defines testing data
testing_data <- tweets[-data_partition, ]
# preps and tokenizes training and testing data
prep_training_data <- itoken(training_data$text, preprocessor = tolower, tokenizer = word_tokenizer, 
ids = training_data$id, progressbar = TRUE)
prep_testing_data <- itoken(testing_data$text, preprocessor  = tolower, tokenizer = word_tokenizer, 
ids = testing_data$id, progressbar = TRUE)
# creates vocabulary and document-term matrix
vocabulary <- create_vocabulary(prep_training_data)
# creates vectorizor
vectorizer <- vocab_vectorizer(vocabulary)
# creates a displacement tracking matrix of training data
training_dtm <- create_dtm(prep_training_data, vectorizer)
# creates a displacement tracking matrix of testing data
testing_dtm <- create_dtm(prep_testing_data, vectorizer)
# initializes new term frequency-inverse document frequency model
tfidf <- TfIdf$new()
# fit the model to the training data and transform it with the fitted model
training_dtm_tfidf <- fit_transform(training_dtm, tfidf)
# fit the model to the testing data and transform it with the fitted model
testing_dtm_tfidf <- fit_transform(testing_dtm, tfidf)
# initializes timer
timer <- Sys.time()
# trains the model
model <- cv.glmnet(x = training_dtm_tfidf, y = training_data[['sentiment']], family = 'binomial', alpha = 1,
type.measure = "auc", nfolds = 5, thresh = 1e-3, maxit = 1e3)
# displays time for the network to train
print(difftime(Sys.time(), timer, units = 'mins'))
# creates a graph of the models performance progress
plot(model)
# displays maximum area under curve
print(paste("maximum area under curve =", round(max(model$cvm), 4)))
# predicts positiveness
positive_probability_tm <- predict(model, testing_dtm_tfidf, type = 'response')[ ,1]
# adds rates to initial dataset
glmnet:::auc(as.numeric(testing_data$sentiment), positive_probability_tm)
# saves the model to RDS file
saveRDS(model, 'model.RDS')

# connect to Twitter API
download.file(url = "http://curl.haxx.se/ca/cacert.pem",
destfile = "cacert.pem")
customer_key <- 'key'
customer_secret <- 'secret'
access_token <- 'token'
access_secret <- 'secret'

setup_twitter_oauth(customer_key, customer_secret, access_token, access_secret)
data_frame <- twListToDF(searchTwitter('editbutton OR #editbutton', n = 150, lang = 'en')) %>%
# converting some symbols
dmap_at('text', convert_syntax)

# preprocessing and tokenization
prep_data <- itoken(data_frame$text, preprocessor = tolower, tokenizer = word_tokenizer, ids = data_frame$id, progressbar = TRUE)
# creating vocabulary and document-term matrix
tweet_dtm <- create_dtm(prep_data, vectorizer)
# transforming data with tf-idf
tweet_dtm_tfidf <- fit_transform(tweet_dtm, tfidf)
# loading classification model
model <- readRDS('model.RDS')
# predicts positiveness
positive_probability <- predict(model, tweet_dtm_tfidf, type = 'response')[ ,1]
# adding rates to initial dataset
data_frame$sentiment <- positive_probability

# defines colors used to ilistrate user sentiment
color_scale <- c("#ce472e", "#f05336", "#ffd73e", "#eec73a", "#4ab04a")
# creates a scatter plot that displays sentiment over time and color codes sentiment on the y axis
ggplot(data_frame, aes(x = created, y = sentiment, color = sentiment)) +
theme_minimal() +
# creates a gradient of five colors
scale_color_gradientn(colors = color_scale, limits = c(0, 1),
breaks = seq(0, 1, by = 1/4),
# creates a label at every zero and every fourth of 1 along the y axis
labels = c("0", round(1 / 4 * 1, 1), round(1 / 4 * 2, 1), round(1 / 4 * 3, 1), round(1 / 4 * 4, 1)),
# maps a scale of colors onto values                    
guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
# maps the points onto the graph
geom_point(aes(color = sentiment), alpha = 1) +
# creates lines to better visualize every 25% of the y axis
geom_hline(yintercept = 0.0, color = "black", size = 0.75, alpha = 0.3, linetype = "solid") +
geom_hline(yintercept = 0.25, color = "black", size = 0.75, alpha = 0.3, linetype = "solid") +
geom_hline(yintercept = 0.50, color = "black", size = 0.75, alpha = 0.3, linetype = "solid") +
geom_hline(yintercept = 0.75, color = "black", size = 0.75, alpha = 0.3, linetype = "solid") +
geom_hline(yintercept = 1, color = "black", size = 0.75, alpha = 0.3, linetype = "solid") +
# creates a trend-line through the scatter plot
geom_smooth(size = 1, alpha = 0.2) +
# positions the legend at the bottom of the graph
theme(legend.position = 'bottom',
legend.direction = "horizontal",
# sets fonts for all graph titles
plot.title = element_text(size = 20, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
axis.title.x = element_text(size = 16),
axis.title.y = element_text(size = 16),
axis.text.y = element_text(size = 8, face = "bold", color = 'black'),
axis.text.x = element_text(size = 8, face = "bold", color = 'black')) +
# creates a title
ggtitle("Sentiment on Twitters Edit Button")


