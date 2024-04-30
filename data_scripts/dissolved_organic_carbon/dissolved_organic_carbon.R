library(tidyverse)
library(pins)

dissolved_organic_carbon <- read_csv('https://github.com/byuistats/data/raw/master/DissolvedOrganicCarbon/DissolvedOrganicCarbon.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, dissolved_organic_carbon, type = "parquet")

pin_name <- "dissolved_organic_carbon"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))