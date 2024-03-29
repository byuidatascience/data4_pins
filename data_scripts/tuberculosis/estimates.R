library(tidyverse)


tb_estimates <- read_csv("https://extranet.who.int/tme/generateCSV.asp?ds=estimates")

# Data details
dpr_document(tb_estimates, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "tb_estimates", 
             title = "Word Health Organization (WHO) Tuberculosis csv file column names",
             description = "File found at https://extranet.who.int/tme/generateCSV.asp?ds=dictionary",
             source = "https://www.who.int/tb/country/data/download/en/",
             var_details = list(nothing = "nothing"))

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, tb_estimates, type = "parquet")

pin_name <- "tb_estimates"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))