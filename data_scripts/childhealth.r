pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

set.seed(150)

tdat <- tempfile()
download("https://github.com/stefvanbuuren/brokenstick/raw/71dc99e62ce57b58d5c1d2a1074fbd4bf394e559/data/smocc_hgtwgt.rda",tdat, mode = "wb")

load(tdat)

childhealth_dutch <- smocc_hgtwgt %>%
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz)



childhealth_dutch_description <- list(subjid = "unique identifyer of each child",
                                      sex = "Male or Female",
                                      agedays = "Age in days",
                                      gagebrth = "Gestational age at birth (days)",
                                      htcm = "Length/height in cm (34-102)",
                                      wtkg = "Weight measurement in kg (0.8-20.5)",
                                      haz = "Height in SDS relative to WHO child growth standard",
                                      waz = "Weight in SDS relative to WHO child growth standard")
dpr_export(childhealth_dutch, export_folder = path(package_path, "data-raw"), 
           export_format = c(".csv", ".json", ".xlsx", ".sav", ".dta"))
dpr_document(childhealth_dutch, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "childhealth_dutch", title = "Child height and weight measurements",
             description = "Longitudinal height and weight measurements during ages 0-2 years for a representative sample of 1,933 Dutch children born in 1988-1989.",
             source = "https://github.com/stefvanbuuren/brokenstick",
             var_details = childhealth_dutch_description)


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