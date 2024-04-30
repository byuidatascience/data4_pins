library(tidyverse)
library(pins)
library(connectapi)

mla <- read_csv('https://github.com/byuistats/data/raw/master/MLA_Data/MLA_Data.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, mla, type = "parquet", access_type = "all")

pin_name <- "mla"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))