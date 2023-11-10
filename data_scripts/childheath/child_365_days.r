pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

hbgd_temp <- tempfile()
download('https://github.com/HBGDki/hbgd/raw/master/data/cpp.rda', hbgd_temp, mode = 'wb')
load(hbgd_temp) #cpp object

tdat <- tempfile()
download("https://github.com/stefvanbuuren/brokenstick/raw/71dc99e62ce57b58d5c1d2a1074fbd4bf394e559/data/smocc_hgtwgt.rda",tdat, mode = "wb") #smocc_hgtwgt object
load(tdat)


childhealth_dutch <- smocc_hgtwgt |>
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz)

childhealth_us <- cpp %>%
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz, mrace, mage, meducyrs, ses)

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


days_365 <- bind_rows(
  childhealth_dutch %>%
    filter(agedays %in% c(363:369)) %>%
    select(subjid, sex, htcm, wtkg, haz, waz) %>%
    mutate(country = "Netherlands", subjid = as.character(subjid)),
  
  childhealth_maled %>%
    filter(agedays %in% c(363:369)) %>%
    select(subjid, sex, htcm = stcm, wtkg, lhaz, waz, country) %>%
    rename(haz = lhaz),
  
  childhealth_us %>%
    filter(agedays == 366) %>%
    select(subjid, sex, htcm, wtkg, haz, waz) %>%
    mutate(country = "United States", subjid = as.character(subjid))
) %>%
  as_tibble()

dpr_document(days_365, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "days_365", title = "Child height and weight measurements for all data from three studies at one year of age.",
             description = "A subset of measurements from the three studies.",
             source = "https://github.com/stefvanbuuren/brokenstick, https://github.com/hafen/hbgd, and https://clinepidb.org/ce/app/record/dataset/DS_5c41b87221",
             var_details = days_365_description)

days_365_description <- list(subjid = "unique identifyer of each child",
                             sex = "Male or Female",
                             wtkg = "Weight measurement in kg (0.8-20.5)",
                             htcm = "Height in cm",
                             haz = "Height for age in SDS relative to WHO child growth standard",
                             waz = "Weight for age in SDS relative to WHO child growth standard",
                             country = "Label for the varied countries")





board <- board_connect()

pin_write(board, days_365, type = "parquet", access_type = "all")
