---
title: "Movie Ratings Analysis"
author: "Hamdaan"
date: "2024-09-30"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

## Including Plots

You can also embed plots, for example:

```{r}
# Load the necessary packages
library(rvest)
library(dplyr)
library(ggplot2)
library(readr)
library(stringr)

# Step 1: Specifying the URL to extract movie data
url <- "http://dataquestio.github.io/web-scraping-pages/IMDb-DQgp.html"

# Step 2: Load the web page content
wp_content <- read_html(url)

# Step 3: Extracting Movie's Titles
title_selector <- ".lister-item-header a"
titles <- wp_content %>% 
  html_nodes(title_selector) %>% 
  html_text()

# Step 4: Extracting Movie's Years
year_selector <- ".lister-item-year"
years <- wp_content %>% 
  html_nodes(year_selector) %>% 
  html_text() %>%
  readr::parse_number()  # Converting years from character to numeric

# Step 5: Extracting Movie's Runtimes
runtime_selector <- ".runtime"
runtimes <- wp_content %>% 
  html_nodes(runtime_selector) %>% 
  html_text() %>%
  readr::parse_number()  # Converting runtimes from character to numeric

# Step 6: Extracting Movie's Genres
genre_selector <- ".genre"
genres <- wp_content %>% 
  html_nodes(genre_selector) %>% 
  html_text() %>%
  stringr::str_trim()  # Removing whitespaces

# Step 7: Extracting Movie's User Ratings
user_rating_selector <- ".ratings-imdb-rating"
user_ratings <- wp_content %>% 
  html_nodes(user_rating_selector) %>% 
  html_attr("data-value") %>%
  as.numeric()  # Converting ratings from character to numeric

# Step 8: Extracting Movie's Metascores
metascore_selector <- ".metascore"
metascores <- wp_content %>% 
  html_nodes(metascore_selector) %>% 
  html_text() %>%
  stringr::str_trim() %>%
  as.numeric()  # Converting metascores from character to numeric

# Step 9: Extracting Movie's Votes
vote_selector <- ".sort-num_votes-visible :nth-child(2)"
votes <- wp_content %>% 
  html_nodes(vote_selector) %>% 
  html_text() %>%
  readr::parse_number()  # Converting votes from character to numeric

# Check the lengths of each vector
cat("Length of titles:", length(titles), "\n")
cat("Length of years:", length(years), "\n")
cat("Length of runtimes:", length(runtimes), "\n")
cat("Length of genres:", length(genres), "\n")
cat("Length of user ratings:", length(user_ratings), "\n")
cat("Length of metascores:", length(metascores), "\n")
cat("Length of votes:", length(votes), "\n")

# Step 10: Adjust for any missing values
max_length <- max(length(titles), length(years), length(runtimes), length(genres), length(user_ratings), length(metascores), length(votes))

titles <- c(titles, rep(NA, max_length - length(titles)))
years <- c(years, rep(NA, max_length - length(years)))
runtimes <- c(runtimes, rep(NA, max_length - length(runtimes)))
genres <- c(genres, rep(NA, max_length - length(genres)))
user_ratings <- c(user_ratings, rep(NA, max_length - length(user_ratings)))
metascores <- c(metascores, rep(NA, max_length - length(metascores)))
votes <- c(votes, rep(NA, max_length - length(votes)))

# Step 11: Creating a Dataframe
movie_df <- tibble::tibble("title" = titles, 
                           "year" = years, 
                           "runtime" = runtimes, 
                           "genre" = genres, 
                           "rating" = floor(user_ratings), 
                           "metascore" = metascores,
                           "vote" = votes)

# Check the dataframe
print(movie_df)

# Step 12: Create a Boxplot
ggplot(data = movie_df,
       aes(x = rating, y = vote, group = rating)) +
  geom_boxplot() +
  labs(title = "Boxplot of Votes vs. Ratings",
       x = "User Ratings",
       y = "Number of Votes")


```
