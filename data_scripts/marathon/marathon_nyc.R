pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapi)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)



# Wrangle
marathon_nyc <- dat %>%
  filter(marathon == "New York City Marathon", !is.na(gender)) %>%
  group_by(year, gender) %>%
  sample_frac(size = .5) %>%
  ungroup()



board <- board_connect()
pin_write(board, marathon_nyc, type = "parquet")

pin_name <- "marathon_nyc"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))


# # Data details
# dpr_document(marathon_nyc, extension = ".R.md", export_folder = usethis::proj_get(),
#              object_name = "marathon_nyc", title = "A random sample of 50% of males and females for each year of runners for all years of the New York City marathon where gender is recorded.",
#              description = "This data set has just over 200k runners. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1. The NYC marathon website - https://www.nyrr.org/tcsnycmarathon",
#              source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
#              var_details = list(age = "The age of the runner", 
#                                 gender = "The gender of the runner (M/F)",
#                                 chiptime = "The time in minutes for the runner",
#                                 year = "The year of the marathon",
#                                 marathon = "The name of the marathon",
#                                 country = "The country where the marathon was held",
#                                 finishers = "The number of finishers at the marathon") )