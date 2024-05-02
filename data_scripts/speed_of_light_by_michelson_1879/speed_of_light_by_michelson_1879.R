library(tidyverse)
library(pins)
library(connectapi)

speed_of_light_by_michelson_1879 <- read_csv('https://github.com/byuistats/data/raw/master/SpeedOfLightByMichelson1879/SpeedOfLightByMichelson1879.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, speed_of_light_by_michelson_1879, type = "parquet", access_type = "all")

pin_name <- "speed_of_light_by_michelson_1879"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))