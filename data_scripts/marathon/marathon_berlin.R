pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapi)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)




# Wrangling for Berlin marathon data
marathon_berlin <- dat %>%
  filter(marathon == "Berlin Marathon", !is.na(gender)) %>%
  group_by(year, gender) %>%
  sample_frac(size = .5) %>%
  ungroup()




board <- board_connect()
pin_write(board, marathon_berlin, type = "parquet")

pin_name <- "marathon_berlin"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))



# # Info about the Berlin dataset that needs to be put into the qmd eventually
# dpr_document(marathon_berlin, extension = ".R.md", export_folder = usethis::proj_get(),
#              object_name = "marathon_berlin", 
#              title = "The 50% sample of male/female runners for all years of the Berlin marathon that recorded gender.",
#              description = "This data set has ~200k observations.  Marathon website - https://www.bmw-berlin-marathon.com/en/",
#              source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
#              var_details = list(age = "The age of the runner", 
#                                 gender = "The gender of the runner (M/F)",
#                                 chiptime = "The time in minutes for the runner",
#                                 year = "The year of the marathon",
#                                 marathon = "The name of the marathon",
#                                 country = "The country where the marathon was held",
#                                 finishers = "The number of finishers at the marathon") )