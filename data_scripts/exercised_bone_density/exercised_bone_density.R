library(tidyverse)
library(pins)

exercised_bone_density <- read_csv('https://github.com/byuistats/data/raw/master/ExercisedBoneDensity/ExercisedBoneDensity.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, exercised_bone_density, type = "parquet")

pin_name <- "exercised_bone_density"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))