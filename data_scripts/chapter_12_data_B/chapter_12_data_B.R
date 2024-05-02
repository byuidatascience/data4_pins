library(tidyverse)
library(pins)
library(connectapi)

chapter_12_data_B <- read_csv('https://github.com/byuistats/data/raw/master/Chapter12DataB/Chapter12DataB.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, chapter_12_data_B, type = "parquet", access_type = "all")

pin_name <- "chapter_12_data_B"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))