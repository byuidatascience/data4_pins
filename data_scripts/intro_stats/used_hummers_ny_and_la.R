library(tidyverse)
library(pins)
library(connectapi)

used_hummers_ny_and_la <- read_csv('https://github.com/byuistats/data/raw/master/UsedHummersNYandLA/UsedHummersNYandLA.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, used_hummers_ny_and_la, type = "parquet", access_type = "all")

pin_name <- "used_hummers_ny_and_la"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))