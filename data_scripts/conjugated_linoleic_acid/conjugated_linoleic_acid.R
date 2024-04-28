library(tidyverse)
library(pins)

conjugated_linoleic_acid <- read_csv('https://github.com/byuistats/data/raw/master/ConjugatedLinoleicAcid/ConjugatedLinoleicAcid.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, conjugated_linoleic_acid, type = "parquet")

pin_name <- "conjugated_linoleic_acid"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))