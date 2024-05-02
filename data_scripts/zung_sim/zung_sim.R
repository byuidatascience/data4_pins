library(tidyverse)
library(pins)
library(connectapi)

zung_sim <- read_csv('https://github.com/byuistats/data/raw/master/ZungSim/ZungSim.csv') %>% 
  select(!Comments) # Delete the description column, it is in the qmd


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, zung_sim, type = "parquet", access_type = "all")

pin_name <- "zung_sim"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))