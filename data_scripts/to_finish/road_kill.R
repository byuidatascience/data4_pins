pacman::p_load(tidyverse, pins, connectapi, googledrive)

# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "Roadkill"))
tempf <- tempfile()
drive_download(google_file, tempf)
roadkill <-  read_csv(tempf) |>
  mutate(
    observed = lubridate::ymd_hms(observed),
    reported = lubridate::ymd_hms(reported),
    gmu = as.integer(gmu)
  )

count(roadkill, species) |> arrange(desc(n))

roadkill |>
  mutate(
    observed_month = month(observed),
    observed_year = year(observed)) |>
  count(species, county, region, highway, observed_year, observed_month, name = "kills") |>
  ggplot(aes(x = observed_month, y = kills, color = observed_year)) +
  geom_point()
