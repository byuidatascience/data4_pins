library(tidyverse)
library(pins)
library(connectapi)

baby_boom <- read_csv('https://github.com/byuistats/data/raw/master/BabyBoom-JSE/BabyBoom-JSE.csv')

baby_boom <- baby_boom %>% 
  select(!Time)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, baby_boom, type = "parquet", access_type = "all")

pin_name <- "baby_boom"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
