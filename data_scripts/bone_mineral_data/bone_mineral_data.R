library(tidyverse)
library(pins)

bone_mineral_data <- read_csv('https://github.com/byuistats/data/raw/master/Bone_Mineral_Data/Bone_Mineral_Data.csv') %>% 
  select(!Description) # Remove the column that contains the description because it doesn't belong in the data


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, bone_mineral_data, type = "parquet")

pin_name <- "bone_mineral_data"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))