library(tidyverse)
library(pins)
library(connectapi)

hubbles_constant_supernovas <- read_csv('https://github.com/byuistats/data/raw/master/HubblesConstant-Supernovas/HubblesConstant-Supernovas.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, hubbles_constant_supernovas, type = "parquet", access_type = "all")

pin_name <- "hubbles_constant_supernovas"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))