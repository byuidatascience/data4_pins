library(tidyverse)

dasl_cheese <- read_csv('https://github.com/byuistats/data/raw/master/DASL-Cheese/DASL-Cheese.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, dasl_cheese, type = "parquet")

pin_name <- "dasl_cheese"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))