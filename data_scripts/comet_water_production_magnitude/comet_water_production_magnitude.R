library(tidyverse)
library(pins)
library(connectapi)

comet_water_production_magnitude <- read_csv('https://github.com/byuistats/data/raw/master/Comet-WaterProduction-Magnitude/Comet-WaterProduction-Magnitude.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, comet_water_production_magnitude, type = "parquet", access_type = "all")

pin_name <- "comet_water_production_magnitude"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))