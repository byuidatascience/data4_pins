library(tidyverse)
library(pins)
library(connectapi)

uranium_plant_data_lead <- read_csv('https://github.com/byuistats/data/raw/master/UraniumPlantData-Lead/UraniumPlantData-Lead.csv') %>% 
  select(Lead..mg.kg.) # Drop the 5 empty columns


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, uranium_plant_data_lead, type = "parquet", access_type = "all")

pin_name <- "uranium_plant_data_lead"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))