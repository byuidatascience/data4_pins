library(tidyverse)


tb_budget <- read_csv("https://extranet.who.int/tme/generateCSV.asp?ds=budget")

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, tb_budget, type = "parquet")

pin_name <- "tb_budget"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))