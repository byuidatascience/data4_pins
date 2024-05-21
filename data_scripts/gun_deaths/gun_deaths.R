pacman::p_load(tidyverse, pins, connectapi, googledrive, readxl)

library(readr)
library(purrr)
library(magrittr)
library(tibble)

# FUNCTIONS FILE
# Function for downloading and parsing data:
parse_cdc <- function(year, url, folder_path = "death_data") {
  
  #last2 year
  browser()
  l2 <- stringr::str_sub(year, 3, 4)
  fnames <- c("deaths", "guns", "suicide")
  
  #tibble of names
  tnames <- tibble::tibble(
    folder = folder_path,
    start_name = fnames,
    year = l2,
    name = stringr::str_c(start_name, year, sep = "_"),
    file_path_feather = file.path(folder, stringr::str_c(name, ".feather")),
    file_path_rds = file.path(folder, stringr::str_c(name, ".rds"))
  )
  
  # First download data. These are fixed-width files.
  # Layout for recent years (need tweaks for earlier year)
  layout <- readr::fwf_widths(
    widths = c(19, 1, 40, 2, 1, 1, 2, 2, 1, 4,
               1, 2, 2, 2, 2, 1, 1, 1, 16, 4, 1, 1, 1,
               1, 34, 1, 1, 4, 3, 1, 3, 3, 2, 1, 281,
               1, 2, 1, 1, 1, 1, 33, 3, 1, 1),
    col_names = c("drop1", "res_status", "drop2", "education_89",
                  "education_03", "education_flag", "month", "drop3", "sex",
                  "detail_age", "age_flag", "age_recode", "age_recode2", "age_group",
                  "age_infant", "death_place", "marital", "day_of_week", "drop4", "data_year",
                  "at_work", "death_manner", "burial", "autopsy", "drop5", "activity",
                  "injury_place", "underlying_cause", "cause_recode358", "drop6",
                  "cause_recode113", "cause_recode130", "cause_recode39", "drop7", 
                  "multiple_causes", "drop8", "race", "race_bridged", "race_flag",
                  "race_recode", "race_recode2", "drop9", "hispanic", "drop10",
                  "hispanic_recode")
  )
  
  cdc_types = readr::cols(
    drop1 = col_double(), res_status = col_double(), drop2 = col_double(),
    education_89 = col_character(), education_03 = col_double(),
    education_flag = col_double(), month = col_character(),
    drop3 = col_double(), sex = col_character(), detail_age = col_double(),
    age_flag = col_logical(), age_recode = col_character(),
    age_recode2 = col_character(), age_group = col_character(),
    age_infant = col_character(), death_place = col_double(),
    marital = col_character(), day_of_week = col_double(),
    drop4 = col_character(), data_year = col_double(),
    at_work = col_character(), death_manner = col_double(),
    burial = col_character(), autopsy = col_character(),
    drop5 = col_character(), activity = col_double(),
    injury_place = col_double(), underlying_cause = col_character(),
    cause_recode358 = col_character(), drop6 = col_double(),
    cause_recode113 = col_character(), cause_recode130 = col_character(),
    cause_recode39 = col_character(), drop7 = col_logical(),
    multiple_causes = col_character(), drop8 = col_character(),
    race = col_character(), race_bridged = col_character(),
    race_flag = col_double(), race_recode = col_double(),
    race_recode2 = col_double(), drop9 = col_character(),
    hispanic = col_double(), drop10 = col_logical(),
    hispanic_recode = col_double()
  )
  
  
  # files are large.
  options(timeout = 120) # raise to two minutes
  temp <- tempfile()
  utils::download.file(url, temp, quiet = T)
  options(timeout = 60) # back to default
  
  # unzip file to temp folder
  temp_dir <- tempdir()
  zip_info <- unzip(temp, list = TRUE) # get file name.
  unzip(temp, exdir = temp_dir, overwrite = TRUE)
  
  # Read in data
  raw_file <- readr::read_fwf(
    file = file.path(temp_dir, zip_info$Name),
    col_positions = layout,
    col_types = cdc_types
  )
  
  # remove temp files
  tfiles <- list.files(temp_dir, full.names = TRUE)
  #file.remove(tfiles)
  
  
  # Drop empty fields
  raw_file <- raw_file %>%
    dplyr::select(-contains("drop"))
  
  # Subset suicides
  # Suicide codes: X60 - X84, U03, Y870
  suicide_code <- c(stringr::str_c("X", 60:84), "U03", "Y870")
  
  # Gun suicides
  # X72 (Intentional self-harm by handgun discharge)
  # X73 (Intentional self-harm by rifle, shotgun and larger firearm discharge)
  # X74 (Intentional self-harm by other and unspecified firearm discharge)
  
  suicide <- raw_file %>%
    dplyr::filter(underlying_cause %in% suicide_code) %>%
    dplyr::mutate(
      gun = ifelse(underlying_cause %in% c("X72", "X73", "X74"), 1, 0),
      year = year
    )
  
  # Subset firearm deaths
  
  # Firearm death codes
  # Accidental:
  # W32 (Handgun discharge)
  # W33 (Rifle, shotgun and larger firearm discharge)
  # W34 (Discharge from other and unspecified firearms)
  #
  # Suicide:
  # X72 (Intentional self-harm by handgun discharge)
  # X73 (Intentional self-harm by rifle, shotgun and larger firearm discharge)
  # X74 (Intentional self-harm by other and unspecified firearm discharge)
  #
  # Homicide:
  # U01.4 (Terrorism involving firearms)
  # X93 (Assault by handgun discharge)
  # X94 (Assault by rifle, shotgun and larger firearm discharge)
  # X95 (Assault by other and unspecified firearm discharge)
  #
  # Undetermined intent:
  # Y22 (Handgun discharge, undetermined intent)
  # Y23 (Rifle, shotgun and larger firearm discharge, undetermined intent)
  # Y24 (Other and unspecified firearm discharge, undetermined intent)
  #
  # Legal intervention 
  # (Note that we code legal intervention deaths as homicides)
  # Y35.0 (Legal intervention involving firearm discharge)
  # Add categorical variable for intent, weapon, plus dummy for police shootings
  
  guns <- raw_file %>%
    dplyr::filter(underlying_cause %in% 
                    c("W32", "W33", "W34", "X72", "X73", "X74", "U014",
                      "X93", "X94", "X95", "Y22", "Y23", "Y24", "Y350")) %>%
    dplyr::mutate(
      intent = dplyr::case_when(
        underlying_cause %in% c("W32", "W33", "W34") ~ "Accidental",
        underlying_cause %in% c("X72", "X73", "X74") ~ "Suicide",
        underlying_cause %in% c("*U01.4", "X93", "X94", "X95",
                                "Y350") ~ "Homicide",
        underlying_cause %in% c("Y22", "Y23", "Y24") ~ "Undetermined",
        TRUE ~ NA_character_),
      police = ifelse(underlying_cause == "Y350", 1, 0),
      weapon = dplyr::case_when(
        underlying_cause %in% c("W32", "X72", "X93", "Y22") ~ "Handgun",
        underlying_cause %in% c("W33", "X73", "X94", "Y23") ~ "Rifle etc",
        TRUE ~ "Other/unknown"),
      # Create a cleaner age variable. Every age under 1 year will "0"
      age = dplyr::case_when(
        stringr::str_sub(detail_age, 1, 1) == "1" ~
          as.numeric(stringr::str_sub(detail_age, 2, 4)),
        detail_age == 9999 ~ NA_real_,
        TRUE ~ 0),
      age = ifelse(age == 999, NA, age),
      year = year)
  
  ## save files
  
  # create folder
  suppressWarnings(
    dir.create(folder_path)
  ) 
  
  # suicide
  readr::write_rds(suicide,
                   tnames %>%
                     dplyr::filter(start_name == "suicide") %>%
                     dplyr::pull(file_path_rds))
  
  # guns
  readr::write_rds(guns,
                   tnames %>%
                     dplyr::filter(start_name == "guns") %>%
                     dplyr::pull(file_path_rds))
  
  # Save 'all_deaths' file
  readr::write_rds(raw_file,
                   tnames %>%
                     dplyr::filter(start_name == "deaths") %>%
                     dplyr::pull(file_path_rds))
  
  print(stringr::str_c("make sure to add ",
                       folder_path,
                       " to your .gitignore if you are using git"))
}


# Old function


# NOTE THAT EACH FILE IS approx. 1gb

# Function for downloading and parsing data:
CDC_parser <- function(year, url) {
  
  # Set up files
  browser()
  all_deaths_name <- paste0("deaths_", substr(year, 3, 4))
  all_deaths_save <- paste0("all_deaths_", substr(year, 3, 4), ".RData")
  gun_name <- paste0("guns_", substr(year, 3, 4))
  gun_save <- paste0("gun_deaths_", substr(year, 3, 4), ".RData")
  suicide_name <- paste0("suicide_", substr(year, 3, 4))
  suicide_save <- paste0("suicide_", substr(year, 3, 4), ".RData")
  
  # First download data. These are fixed-width files.
  # Layout for recent years (need tweaks for earlier year)
  layout <- fwf_widths(c(19,1,40,2,1,1,2,2,1,4,1,2,2,2,2,1,1,1,16,4,1,1,1,1,34,1,1,4,3,1,3,3,2,1,281,1,2,1,1,1,1,33,3,1,1),
                       col_names = c("drop1", "res_status", "drop2", "education_89", "education_03", "education_flag", "month", 
                                     "drop3", "sex", "detail_age", "age_flag", "age_recode", "age_recode2", "age_group", 
                                     "age_infant", "death_place", "marital", "day_of_week", "drop4", "data_year", "at_work", 
                                     "death_manner", "burial", "autopsy", "drop5", "activity", "injury_place", 
                                     "underlying_cause", "cause_recode358", "drop6", "cause_recode113", "cause_recode130", 
                                     "cause_recode39", "drop7", "multiple_causes", "drop8", "race", "race_bridged", "race_flag", 
                                     "race_recode", "race_recode2", "drop9", "hispanic", "drop10", "hispanic_recode"))
  
  temp <- tempfile()
  download.file(url, temp, quiet = T)
  
  # Read in data
  raw_file <- read_fwf(unzip(temp), layout)
  
  # Drop empty fields
  raw_file <- raw_file %>%
    select(-contains("drop"))
  
  # Save 'all_deaths' file
  assign(eval(all_deaths_name), raw_file)
  save(list = all_deaths_name, file = all_deaths_save)
  
  # Subset suicides
  # Suicide codes: X60 - X 84, U03, Y870
  
  suicide_code <- list()
  for (i in 1:24) {
    suicide_code[[i]] <- paste0("X", i + 59)
  }
  suicide_code[length(suicide_code)+1] <- "U03"
  suicide_code[length(suicide_code)+1] <- "Y870"
  
  # Gun suicides
  # X72 (Intentional self-harm by handgun discharge)
  # X73 (Intentional self-harm by rifle, shotgun and larger firearm discharge)
  # X74 (Intentional self-harm by other and unspecified firearm discharge)
  
  suicide <- raw_file %>%
    filter(underlying_cause %in% suicide_code) %>%
    mutate(gun = ifelse(underlying_cause %in% c("X72", "X73", "X74"), 1, 0),
           year = year)  
  
  assign(eval(suicide_name), suicide)
  save(list = suicide_name, file = suicide_save)
  rm(suicide)
  rm(list = suicide_name)
  
  # Subset firearm deaths
  
  # Firearm death codes
  # Accidental:
  # W32 (Handgun discharge)
  # W33 (Rifle, shotgun and larger firearm discharge)
  # W34 (Discharge from other and unspecified firearms)
  # 
  # Suicide:
  # X72 (Intentional self-harm by handgun discharge)
  # X73 (Intentional self-harm by rifle, shotgun and larger firearm discharge)
  # X74 (Intentional self-harm by other and unspecified firearm discharge)
  # 
  # Homicide:
  # U01.4 (Terrorism involving firearms)
  # X93 (Assault by handgun discharge)
  # X94 (Assault by rifle, shotgun and larger firearm discharge)
  # X95 (Assault by other and unspecified firearm discharge)
  # 
  # Undetermined intent:
  # Y22 (Handgun discharge, undetermined intent)
  # Y23 (Rifle, shotgun and larger firearm discharge, undetermined intent)
  # Y24 (Other and unspecified firearm discharge, undetermined intent)
  # 
  # Legal intervention (Note that we code legal intervention deaths as homicides)
  # Y35.0 (Legal intervention involving firearm discharge)
  
  guns <- raw_file %>%
    filter(underlying_cause %in% c("W32", "W33", "W34", "X72", "X73", "X74", "U014", "X93", "X94", "X95", "Y22", "Y23", "Y24", "Y350"))
  
  rm(raw_file)
  
  # Add categorical variable for intent, weapon, plus dummy for police shootings
  guns <- guns %>%
    mutate(intent = ifelse(underlying_cause %in% c("W32", "W33", "W34"), "Accidental",
                           ifelse(underlying_cause %in% c("X72", "X73", "X74"), "Suicide",
                                  ifelse(underlying_cause %in% c("*U01.4", "X93", "X94", "X95", "Y350"), "Homicide",
                                         ifelse(underlying_cause %in% c("Y22", "Y23", "Y24"), "Undetermined", NA)))),
           police = ifelse(underlying_cause == "Y350", 1, 0),
           weapon = ifelse(underlying_cause %in% c("W32", "X72", "X93", "Y22"), "Handgun",
                           ifelse(underlying_cause %in% c("W33", "X73", "X94", "Y23"), "Rifle etc",
                                  "Other/unknown")),
           year = year) # Dummy for young men (15-34)
  
  # Create a cleaner age variable. Every age under 1 year will be coded as "0"
  guns <- guns %>%
    mutate(age = ifelse(substr(detail_age, 1, 1) == "1", as.numeric(substr(detail_age, 2, 4)), # Year
                        ifelse(detail_age == 9999, NA, 0)),
           age = ifelse(age == 999, NA, age))
  
  assign(eval(gun_name), guns)
  save(list = gun_name, file = gun_save)
  rm(guns)
  rm(list = gun_name)
  
}


# PARSE DATA FILE
# Now run the function for each year you want:
parse_cdc(2022, "https://ftp.cdc.gov/pub/health_statistics/NCHS/Datasets/DVS/mortality/mort2022ps.zip")
https://ftp.cdc.gov/pub/health_statistics/NCHS/Datasets/DVS/mortality/
  https://ftp.cdc.gov/pub/health_statistics/NCHS/Datasets/DVS/mortality/mort2022ps.zip

#########################################################################################################################

# The code below processes the data for FiveThirtyEight's Gun Deaths in America project

# For the project, we used the three most recent years available: 2012-14
# We'll combine these into a single data frame.
# In keeping with CDC practice, we'll eliminate deaths of non-U.S. residents
rds_guns <- list.files("death_data", "guns", full.names = TRUE)

all_guns <- purrr::map(rds_guns, ~read_rds(.x)) %>%
  dplyr::bind_rows() %>%
  dplyr::filter(res_status != 4)

# Create new categorical variables for place of injury, educational status, and race/ethnicity.
# For race/ethnicity, we used five non-overlapping categories: 
# Hispanic, non-Hispanic white, non-Hispanic black, non-Hispanic Asian/Pacific Islander, non-Hispanic Native American/Native Alaskan

all_guns <- all_guns %>%
  mutate(
    place = factor(injury_place, 
                   labels = c("Home", "Residential institution", "School/instiution",
                              "Sports", "Street", "Trade/service area", "Industrial/construction",
                              "Farm", "Other specified", "Other unspecified")),
    education = ifelse(education_flag == 1,
                       cut(as.numeric(education_03), breaks = c(0, 2, 3, 5, 8, 9)),
                       cut(as.numeric(education_89), breaks = c(0, 11, 12, 15, 17, 99))) %>%
      factor(labels = c("Less than HS", "HS/GED", "Some college", "BA+", NA)),
    race = case_when(
      hispanic > 199 & hispanic < 996 ~ "Hispanic",
      race == "01" ~ "White",
      race == "02" ~ "Black",
      as.numeric(race) >= 4 & as.numeric(race) <= 78 ~ "Asian/Pacific Islander",
      is.na(race) ~ "Uknown",
      # I think this step matches their code.
      TRUE ~ "Native American/Native Alaskan")) %>% 
  select(year, month, intent, police, sex,
         age, race, hispanic, place, education)

# This is the main data frame FiveThirtyEight used in its analysis.
# For example:
# Gun suicides by year:
readr::write_rds(all_guns, "full_data.rds")
readr::write_csv(all_guns, "full_data.csv")