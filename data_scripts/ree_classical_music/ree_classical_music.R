library(tidyverse)
library(pins)
library(connectapi)

ree_classical_music <- read_csv('https://github.com/byuistats/data/raw/master/REE-ClassicalMusic/REE-ClassicalMusic.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, ree_classical_music, type = "parquet", access_type = "all")

pin_name <- "ree_classical_music"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))