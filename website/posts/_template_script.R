# Load the libraries used by this script
library(tidyverse)
library(pins)
library(connectapi)

# Retreive data
dataset_name <- read_csv('')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, dataset_name, type = "parquet", access_type = "all")

pin_name <- "dataset_name"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))