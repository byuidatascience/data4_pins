library(tidyverse)
library(pins)

coin_toss_heads <- read_csv('https://github.com/byuistats/data/raw/master/CoinTossHeads/CoinTossHeads.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, coin_toss_heads, type = "parquet")

pin_name <- "coin_toss_heads"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))