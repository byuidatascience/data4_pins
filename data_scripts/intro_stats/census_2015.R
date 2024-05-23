library(tidyverse)
library(pins)
library(connectapi)

census_2015 <- read_csv('https://github.com/byuistats/data/raw/master/census2015/census2015.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, census_2015, type = "parquet", access_type = "all")

pin_name <- "census_2015"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))