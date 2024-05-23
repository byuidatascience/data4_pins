library(tidyverse)
library(pins)
library(connectapi)

oreo_double_stuf <- read_csv('https://github.com/byuistats/data/raw/master/OreoDoubleStuf/OreoDoubleStuf.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, oreo_double_stuf, type = "parquet", access_type = "all")

pin_name <- "oreo_double_stuf"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))