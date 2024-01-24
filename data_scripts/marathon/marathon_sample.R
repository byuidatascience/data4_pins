pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapi)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)



# Wrangle
marathon_sample <- dat %>%
  filter(finishers > 50) %>%
  group_by(marathon, year, gender) %>%
  sample_n(50, replace = TRUE) %>%
  ungroup() %>%
  mutate(finishers = as.integer(finishers), year = as.integer(year))



board <- board_connect()
pin_write(board, marathon_sample, type = "parquet")

pin_name <- "marathon_sample"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))


# 
# # Data details
# dpr_document(marathon_sample, extension = ".R.md", export_folder = usethis::proj_get(),
#              object_name = "marathon_sample", title = "A resampled set of runners from all marathons with more 50 runners.",
#              description = "Each marathon will have 100 runners (50 male, 50 female) per year. So any marathon with less than 50 runners in the group will have multiple resampled runners. This data set has over 500k runners. The original data had close to 10 million runners and a few more columns. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1",
#              source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
#              var_details = list(age = "The age of the runner", 
#                                 gender = "The gender of the runner (M/F)",
#                                 chiptime = "The time in minutes for the runner",
#                                 year = "The year of the marathon",
#                                 marathon = "The name of the marathon",
#                                 country = "The country where the marathon was held",
#                                 finishers = "The number of finishers at the marathon"))