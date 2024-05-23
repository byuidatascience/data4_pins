library(tidyverse)
library(pins)
library(connectapi)

cardiac_arrest_health <- read_csv('https://github.com/byuistats/data/raw/master/CardiacArrestHealth/CardiacArrestHealth.csv') %>% 
  rename(Health = x) # Rename column to match documentation


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, cardiac_arrest_health, type = "parquet", access_type = "all")

pin_name <- "cardiac_arrest_health"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))