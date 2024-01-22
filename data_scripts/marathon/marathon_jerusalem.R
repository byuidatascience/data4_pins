pacman::p_load(tidyverse, downloader, fs, glue, rvest)


# Data is from master_marathon. Path doesn't exist. 
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Dataset details
dpr_document(marathon_jerusalem, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_jerusalem", 
             title = "The full set of runners for the Jerusalem marathon.",
             description = "This data set has ~2.5k observations.  Marathon website - https://jerusalem-marathon.com/en/home-page/",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Filter for the Jerusalem Marathon only
marathon_jerusalem <- dat %>%
  filter(marathon == "Jerusalem Marathon")




# The parquet thing. Do not run.
# board <- board_connect()
# pin_write(board, marathon_jerusalem, type = "parquet") 
# 
# pin_name <- "marathon_jerusalem"
# meta <- pin_meta(board, paste0("hathawayj/", pin_name))
# client <- connect()
# my_app <- content_item(client, meta$local$content_id)
# set_vanity_url(my_app, paste0("data/", pin_name))