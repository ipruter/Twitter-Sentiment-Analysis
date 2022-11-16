### About Twitter Sentiment Analysis
The program consists of a neural network that analyses tweets and identifies assesses if the tweets express possitive or negative sentiment towards Twitters edit feature. After the data is analysed, a scatter plot displays a visual representation of the sentement.

### Installation
- The program is written in R 4 which is a language developed for statistical computer and designed for working with data set parameters making it ideal for data mining. https://www.r-project.org/ 
- The library mysql.connector contains functions that allow for the use of SQL syntax to be executed within the Python program. 
- The library requests allow python programs to send requests to servers and use the responding content within the program.
- The BeautifulSoup library contains functions that parse HTML syntax and organizes filtered content into a manageable XML file that is easier to parse further and retrieve data from.
- The pandas library is a great Python data analysis tool for manipulating quantitative data and time series.
- scipy is a library used for scientific computing and contains sub packages for clustering and visually representing quantitative data
- The matplotlib library creates mathematic, interactive visualizations for describing statistical data

### How to Use Twitter Sentiment Analysis
The program was written, tested, and intended to run in the Jupyter Notebook environment which is why it is broken up into cells instead of methods for re-use of code. The user-Agent variable needs to be defined to prevent a 404 error. This can be found by inspecting a webpage's HTML and navigating to the network tab, click on the first file listed, select the header tab and scroll down to find the user agent. The program begins by retrieving a table of investors to retrieve data on securities. The investors that are on that table are completely up to you. The table columns are CIK (unique ID) investor's name, and a description, in that order. However, the program only requires a CIK column and an investor name column. The main cell will extract all the data and created tables in your database you can reference outside of the program as well. The following cell will construct a data frame concatenating all of the data extracted and saving it into a data frame of quantitative data. The two cells create a dendrogram and a histogram from the data fame.

### How to Test Edgar Web Scraper
Anytime the program makes a connection to a page on Edgar is displays the status code. The code returned should be a 200 or else there may be a connection issues or denied access to the web page.

