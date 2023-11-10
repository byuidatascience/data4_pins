pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)
hbgd_temp <- tempfile()
download('https://github.com/HBGDki/hbgd/raw/master/data/cpp.rda', hbgd_temp, mode = 'wb')
load(hbgd_temp)

childhealth_us <- cpp %>%
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz, mrace, mage, meducyrs, ses)

childhealth_us_description <- list(subjid = "unique identifyer of each child",
                                   sex = "Male or Female",
                                   agedays = "Age in days",
                                   gagebrth = "Gestational age at birth (days)",
                                   htcm = "Length/height in cm (34-102)",
                                   wtkg = "Weight measurement in kg (0.8-20.5)",
                                   haz = "Height in SDS relative to WHO child growth standard",
                                   waz = "Weight in SDS relative to WHO child growth standard",
                                   mrace = "Race of the mother",
                                   mage = "Mother age at child birth",
                                   meducyrs = "Educational years of mother",
                                   ses = "Socioeconomic status of mother")