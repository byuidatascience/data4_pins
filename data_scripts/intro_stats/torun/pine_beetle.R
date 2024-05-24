library(tidyverse)
library(pins)
library(connectapi)

pine_beetle <- read_csv('https://github.com/byuistats/data/raw/master/PineBeetle/PineBeetle.csv') %>% 
  select(!Notes) # Drop notes column because it contains description in qmd


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, pine_beetle, type = "parquet", access_type = "all")

pin_name <- "pine_beetle"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))