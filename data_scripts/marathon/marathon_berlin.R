pacman::p_load(tidyverse, downloader, fs, glue, rvest)


# Data is from master_marathon. Path doesn't exist. 
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Info about the Berlin dataset that needs to be put into the qmd eventually
dpr_document(marathon_berlin, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_berlin", 
             title = "The 50% sample of male/female runners for all years of the Berlin marathon that recorded gender.",
             description = "This data set has ~200k observations.  Marathon website - https://www.bmw-berlin-marathon.com/en/",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Wrangling for Berlin marathon data
marathon_berlin <- dat %>%
  filter(marathon == "Berlin Marathon", !is.na(gender)) %>%
  group_by(year, gender) %>%
  sample_frac(size = .5) %>%
  ungroup()




# The parquet thing. Do not run.
# board <- board_connect()
# pin_write(board, marathon_berlin, type = "parquet") 
# 
# pin_name <- "marathon_berlin"
# meta <- pin_meta(board, paste0("hathawayj/", pin_name))
# client <- connect()
# my_app <- content_item(client, meta$local$content_id)
# set_vanity_url(my_app, paste0("data/", pin_name))