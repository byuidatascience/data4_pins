pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapis)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)


# Wrangle (filter to 2010)
marathon_2010 <- dat %>%
  filter(year == 2010)



board <- board_connect()
pin_write(board, marathon_2010, type = "parquet")

pin_name <- "marathon_2010"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))


# 
# # Data details
# dpr_document(marathon_2010, extension = ".R.md", export_folder = usethis::proj_get(),
#              object_name = "marathon_2010", title = "The full set of runners for all races during 2010.",
#              description = "This data set has 800k runners. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1.",
#              source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
#              var_details = list(age = "The age of the runner", 
#                                 gender = "The gender of the runner (M/F)",
#                                 chiptime = "The time in minutes for the runner",
#                                 year = "The year of the marathon",
#                                 marathon = "The name of the marathon",
#                                 country = "The country where the marathon was held",
#                                 finishers = "The number of finishers at the marathon") )
