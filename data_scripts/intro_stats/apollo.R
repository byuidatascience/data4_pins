library(tidyverse)
library(pins)
library(connectapi)

apollo <- read_csv('https://github.com/byuistats/data/raw/master/Apollo/Apollo.csv')

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, apollo, type = "parquet", access_type = "all")

pin_name <- "apollo"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
