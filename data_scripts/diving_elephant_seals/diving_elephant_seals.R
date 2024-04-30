library(tidyverse)
library(pins)

diving_elephant_seals <- read_csv('https://github.com/byuistats/data/raw/master/DivingElephantSeals/DivingElephantSeals.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, diving_elephant_seals, type = "parquet")

pin_name <- "diving_elephant_seals"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))