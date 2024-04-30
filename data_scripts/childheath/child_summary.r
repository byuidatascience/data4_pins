pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins, connectapi)

# get three sources
hbgd_temp <- tempfile()
download('https://github.com/HBGDki/hbgd/raw/master/data/cpp.rda', hbgd_temp, mode = 'wb')
load(hbgd_temp) #cpp object

tdat <- tempfile()
download("https://github.com/stefvanbuuren/brokenstick/raw/71dc99e62ce57b58d5c1d2a1074fbd4bf394e559/data/smocc_hgtwgt.rda",tdat, mode = "wb") #smocc_hgtwgt object
load(tdat)

sdrive <- shared_drive_find("byuids_data")
maled_file <- drive_ls(sdrive)  |>
    filter(stringr::str_detect(name, "MALED"))
tempf <- tempfile()
drive_download(maled_file, tempf)
dat <- read_csv(tempf)

# Format source data
childhealth_dutch <- smocc_hgtwgt |>
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz)

childhealth_us <- cpp %>%
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz, mrace, mage, meducyrs, ses)


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


# combine to one file
childhealth_summary <- bind_rows(
  childhealth_dutch %>%
    select(subjid, agedays, sex, htcm, wtkg, haz, waz) %>%
    mutate(country = "Netherlands", subjid = as.character(subjid)),

  childhealth_maled %>%
    select(subjid, agedays,  sex, htcm = stcm, wtkg, lhaz, waz, country) %>%
    rename(haz = lhaz),

  childhealth_us %>%
    select(subjid, agedays, sex, htcm, wtkg, haz, waz) %>%
    mutate(country = "United States", subjid = as.character(subjid))
) %>%
  as_tibble() %>%
  group_by(subjid, sex, country) %>%
  arrange(agedays) %>%
  summarise(haz_mean = mean(haz, na.rm = TRUE), waz_mean = mean(waz), 
            observations = n(), agedays_last = agedays[n()], agedays_first = agedays[1],
            haz_last = haz[n()], haz_first = haz[1], waz_first = waz[1], waz_last = waz[n()]) %>%
  ungroup()

# push to board
board <- board_connect()
pin_write(board, childhealth_summary, type = "parquet", access_type = "all")

pin_name <- "childhealth_summary"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
