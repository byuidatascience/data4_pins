library(tidyverse)
library(pins)

dasl_hot_dog_nutrition <- read_csv('https://github.com/byuistats/data/raw/master/DASL-HotDogNutrition/DASL-HotDogNutrition.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, dasl_hot_dog_nutrition, type = "parquet")

pin_name <- "dasl_hot_dog_nutrition"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))