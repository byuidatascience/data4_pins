pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapi)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)


# Filter for the Jerusalem Marathon only
marathon_jerusalem <- dat %>%
  filter(marathon == "Jerusalem Marathon")




board <- board_connect()
pin_write(board, marathon_jerusalem, type = "parquet")

pin_name <- "marathon_jerusalem"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))

# 
# # Dataset details
# dpr_document(marathon_jerusalem, extension = ".R.md", export_folder = usethis::proj_get(),
#              object_name = "marathon_jerusalem", 
#              title = "The full set of runners for the Jerusalem marathon.",
#              description = "This data set has ~2.5k observations.  Marathon website - https://jerusalem-marathon.com/en/home-page/",
#              source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
#              var_details = list(age = "The age of the runner", 
#                                 gender = "The gender of the runner (M/F)",
#                                 chiptime = "The time in minutes for the runner",
#                                 year = "The year of the marathon",
#                                 marathon = "The name of the marathon",
#                                 country = "The country where the marathon was held",
#                                 finishers = "The number of finishers at the marathon") )
