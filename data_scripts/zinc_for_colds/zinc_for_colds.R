library(tidyverse)
library(pins)
library(connectapi)

zinc_for_colds <- read_csv('https://github.com/byuistats/data/raw/master/ZincForColds/ZincForColds.csv') %>% 
  select(!Souce) # Delete description column


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, zinc_for_colds, type = "parquet", access_type = "all")

pin_name <- "zinc_for_colds"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))