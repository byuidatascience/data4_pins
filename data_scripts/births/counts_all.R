library(tidyverse, pins, connectapi)

# Put the code that builds in all these datasets when it's all working. Then these lines will bind them all together. 
counts_all <- bind_rows(
  mutate(counts_football, group = "football"),
  mutate(counts_baseball, group = "baseball"),
  mutate(counts_hockey, group = "hockey"),
  mutate(counts_basketball, group = "basketball"),
  mutate(counts_us, group = "us")
)

# Data details
# dpr_document(counts_all, extension = ".md.R", export_folder = usethis::proj_get(),
#              object_name = "counts_all", 
#              title = "The count of births of all players and US by month.",
#              description = "Data combined from others sources in package.",
#              source = "https://github.com/byuidatascience/data4births",
#              var_details = counts_all_description)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, counts_all, type = "parquet", access_type = "all")

pin_name <- "counts_all"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))