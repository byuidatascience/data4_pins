library(tidyverse)
library(pins)
library(connectapi)

patient_satisfaction_doctor_vs_nurse <- read_csv('https://github.com/byuistats/data/raw/master/PatientSatisfaction-DoctorVsNurse-Stacked/PatientSatisfaction-DoctorVsNurse-Stacked.csv') %>% 
  select(!Explanation)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, patient_satisfaction_doctor_vs_nurse, type = "parquet", access_type = "all")

pin_name <- "patient_satisfaction_doctor_vs_nurse"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))