library(tidyverse)
library(pins)
library(connectapi)
library(rio) # for import function. read_excel couldn't find the file.

height <- import('https://github.com/byuistats/data/raw/master/height/germanconscr.xlsx')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, height, type = "parquet", access_type = "all")

pin_name <- "height"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))