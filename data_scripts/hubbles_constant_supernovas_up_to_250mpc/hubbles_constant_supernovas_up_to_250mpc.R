library(tidyverse)
library(pins)
library(connectapi)

hubbles_constant_supernovas_up_to_250mpc <- read_csv('https://github.com/byuistats/data/raw/master/HubblesConstant-SupernovasUpTo250Mpc/HubblesConstant-SupernovasUpTo250Mpc.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, hubbles_constant_supernovas_up_to_250mpc, type = "parquet", access_type = "all")

pin_name <- "hubbles_constant_supernovas_up_to_250mpc"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))