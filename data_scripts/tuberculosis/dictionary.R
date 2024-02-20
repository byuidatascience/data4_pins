library(tidyverse)


tb_dictionary <- read_csv("https://extranet.who.int/tme/generateCSV.asp?ds=dictionary")

# Data details
dpr_document(tb_dictionary, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "tb_dictionary", 
             title = "Word Health Organization (WHO) Tuberculosis csv file column names",
             description = "File found at https://extranet.who.int/tme/generateCSV.asp?ds=dictionary",
             source = "https://www.who.int/tb/country/data/download/en/",
             var_details = list(nothing = "nothing"))