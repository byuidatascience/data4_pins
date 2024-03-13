library(tidyverse)


tb_utilization <- read_csv("https://extranet.who.int/tme/generateCSV.asp?ds=expenditure_utilisation")

# Data details
dpr_document(tb_utilization, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "tb_utilization", 
             title = "Word Health Organization (WHO) Tuberculosis expenditures and utilization by country",
             description = "See source for description of the data. tb_dictionary describes the column names.",
             source = "https://www.who.int/tb/country/data/download/en/",
             var_details = list(nothing = "nothing"))


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, tb_utilization, type = "parquet")

pin_name <- "tb_utilization"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))