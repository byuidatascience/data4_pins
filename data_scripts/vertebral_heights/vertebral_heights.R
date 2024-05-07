library(tidyverse)
library(pins)
library(connectapi)

vertebral_heights <- read_csv('https://github.com/byuistats/data/raw/master/VertebralHeights/VertebralHeights.csv') %>% 
  rename(VertebralHeight = x) # Rename column to match documentation


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, vertebral_heights, type = "parquet", access_type = "all")

pin_name <- "vertebral_heights"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))