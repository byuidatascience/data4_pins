## Obfuscate data
# https://clinepidb.org/ce/app/record/dataset/DS_5c41b87221

pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

sdrive <- shared_drive_find("byuids_data")
maled_file <- drive_ls(sdrive)  |>
    filter(stringr::str_detect(name, "MALED"))
tempf <- tempfile()
drive_download(maled_file, tempf)
dat <- read_csv(tempf)

childhealth_maled <- dat %>%
  select(
    subjid = `Participant ID`, sex = Sex, country = Country,
    agedays = `Age (days)`, wtkg = `Weight (kg)`, stcm = `Stature (cm)`,
    htcm = `Height (cm)`, lncm = `Recumbent length (cm)`,
    lh_used = `Recumbent length or height used for stature`,
    hccm = `Head circumference (cm)`,
    lhaz = `Length- or height-for-age z-score`,
    haz = `Height-for-age z-score`, laz= `Length-for-age z-score`,
    waz = `Weight-for-age z-score`, hcaz = `Head circumference-for-age z-score`,
    whz = `Weight-for-length or -height z-score`)

board <- board_connect()
pin_write(board, childhealth_maled, type = "parquet") # adjust permission to campus on site.

pin_name <- "childhealth_maled"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
