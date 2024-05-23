library(tidyverse)
library(pins)
library(connectapi)

freshman_dinner <- read_csv('https://github.com/byuistats/data/raw/master/FreshmenDinner/FreshmenDinner.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, freshman_dinner, type = "parquet", access_type = "all")

pin_name <- "freshman_dinner"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))