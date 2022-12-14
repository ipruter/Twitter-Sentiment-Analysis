### About Twitter Sentiment Analysis
The program consists of a neural network that analyses tweets and identifies assesses if the tweets express positive or negative sentiment towards Twitters edit feature. After the data is analyzed a scatter plot displays a visual representation of the sentiment.

### Installation
- The program is written in R 4 which is a language developed for statistical computer and designed for working with data set parameters making it ideal for data mining. https://www.r-project.org/ 
- The package twitterR enables an r program obtain data from twitter through their API.
- The package ROAuth package allows an r program to authenticate with a server.
- The library Tidyverse contains packages for plotting data in graphs, organizing data into tables and manipulating data.
- The package text2vec provides methods framework for text analysis and natural language processing.
- the package caret contains classification and regression training functions for developing predictive models.
- The package glmnet contains a large variety of regression training functions for developing predictive models.
- The package ggrepel prevents plot text lables from overlapping with one another.

### How to Use Twitter Sentiment Analysis
The program requires the training.1600000.processed.noemoticon.csv file in its directory to initially train the model. This file can be found on Kaggle at https://www.kaggle.com/datasets/ferno2/training1600000processednoemoticoncsv. Once the CSV file is in the directory run the first cell to train the model. Training can take around a half an hour and then displays the area under the ROC curve (AUC).

<img src="https://github.com/ipruter/Twitter-Sentiment-Analysis/blob/main/Images/sa%20nn%20performance.png" height="50%" width="50%" >

The second cell requires that the user has a Twitter "application" that has an associated customer key, customer secret, access token, and access secret. An application is created on a developers account after they have requested and been granted access to Twitters API. In the setup_twitter_oauth() method replace the placeholder variables with your own Twitter application authentication credentials. In the searchTwitter() method a sentiment can be done on a different topic by replacing the key words. Run the second cell and a scatter plot will display the general sentiment of the topic among Twitter users.

<img src="https://github.com/ipruter/Twitter-Sentiment-Analysis/blob/main/Images/sa%20scatter%20plot.png" height="50%" width="50%" >

