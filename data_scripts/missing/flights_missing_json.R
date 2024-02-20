
# Data is from google drive.
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "airlines_missing"))
tempf <- tempfile()
drive_download(google_file, tempf)

# Read it as a JSON.
flights_missing <- fromJSON(tempf) %>%
  flatten() %>%
  as_tibble() %>%
  rename_with(str_to_lower) %>%
  rename_with(~str_replace_all(., " ", "_"))


# Post as a json
board <- board_connect()
pin_write(board, flights_missing_json, type = "json")

pin_name <- "flights_missing_json"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))


# data details
dpr_document(flights_missing, extension = ".md.R", 
             export_folder = usethis::proj_get(),
             object_name = "flights_missing", 
             title = "Missing Airline Delays (US)",
             description = "Monthly Airline Delays by Airport for US Flights, 2003-2016",
             source = "https://think.cs.vt.edu/corgis/datasets/json/airlines/airlines.json 
        and https://github.com/byuistats/CSE250",
             var_details = list(airport_code = "Airport Code", 
                                airport_name = "Airport Name", 
                                month = "Month", 
                                year = "Year", 
                                num_of_flights_total = "Num Of Flights Total", 
                                num_of_delays_carrier = "Num Of Delays Carrier", 
                                num_of_delays_late_aircraft = "Num Of Delays Late Aircraft", 
                                num_of_delays_nas = "Num Of Delays Nas", 
                                num_of_delays_security = "Num Of Delays Security", 
                                num_of_delays_weather = "Num Of Delays Weather", 
                                num_of_delays_total = "Num Of Delays Total", 
                                minutes_delayed_carrier = "Minutes Delayed Carrier", 
                                minutes_delayed_late_aircraft = "Minutes Delayed Late Aircraft", 
                                minutes_delayed_nas = "Minutes Delayed Nas", 
                                minutes_delayed_security = "Minutes Delayed Security", 
                                minutes_delayed_weather = "Minutes Delayed Weather", 
                                minutes_delayed_total = "Minutes Delayed Total"))