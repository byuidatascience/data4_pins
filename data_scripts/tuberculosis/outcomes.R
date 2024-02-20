library(tidyverse)


tb_outcomes <- read_csv("https://extranet.who.int/tme/generateCSV.asp?ds=outcomes")

# Data details
dpr_document(tb_outcomes, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "tb_outcomes", 
             title = "Word Health Organization (WHO) Tuberculosis treatment outcomes by country",
             description = "See source for description of the data. tb_dictionary describes the column names.",
             source = "https://www.who.int/tb/country/data/download/en/",
             var_details = list(nothing = "nothing"))

