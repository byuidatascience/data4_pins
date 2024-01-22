pacman::p_load(tidyverse, downloader, fs, glue, rvest)


# Data is from master_marathon. Path doesn't exist. 
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Dataset details
dpr_document(marathon_big_sur, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_big_sur", 
             title = "The full set of runners for the Big Sur marathon.",
             description = "This data set has ~40k observations.  Marathon website - https://www.bigsurmarathon.org/",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Filter to only the Big Sur Marathon
marathon_big_sur <- dat %>%
  filter(marathon == "Big Sur Marathon")



# The parquet thing. Do not run.
# board <- board_connect()
# pin_write(board, marathon_big_sur, type = "parquet") 
# 
# pin_name <- "marathon_big_sur"
# meta <- pin_meta(board, paste0("hathawayj/", pin_name))
# client <- connect()
# my_app <- content_item(client, meta$local$content_id)
# set_vanity_url(my_app, paste0("data/", pin_name))