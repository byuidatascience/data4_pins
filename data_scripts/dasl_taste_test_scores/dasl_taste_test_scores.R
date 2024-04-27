library(tidyverse)

dasl_taste_test_scores <- read_csv('https://github.com/byuistats/data/raw/master/DASL-TasteTestScores/DASL-TasteTestScores.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, dasl_taste_test_scores, type = "parquet")

pin_name <- "dasl_taste_test_scores"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))