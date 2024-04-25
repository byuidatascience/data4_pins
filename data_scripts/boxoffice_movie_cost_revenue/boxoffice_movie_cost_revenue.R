library(tidyverse)

boxoffice_movie_cost_revenue <- read_csv('https://github.com/byuistats/data/raw/master/Boxoffice_Movie_Cost_Revenue/Boxoffice_Movie_Cost_Revenue.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, boxoffice_movie_cost_revenue, type = "parquet")

pin_name <- "boxoffice_movie_cost_revenue"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))