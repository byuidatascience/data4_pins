library(tidyverse)
library(pins)

factory_assembly_times_sim <- read_csv('https://github.com/byuistats/data/raw/master/FactoryAssemblyTimes-sim/FactoryAssemblyTimes-sim.csv')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, factory_assembly_times_sim, type = "parquet")

pin_name <- "factory_assembly_times_sim"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))