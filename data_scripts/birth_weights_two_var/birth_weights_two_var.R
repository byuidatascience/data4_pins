library(tidyverse)

birth_weights_two_var <- read_csv('https://github.com/byuistats/data/raw/master/BirthWeightsTwoVar/BirthWeightsTwoVar.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, birth_weights_two_var, type = "parquet")

pin_name <- "birth_weights_two_var"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))