# Stuff for whoever does this project next 

This is Elena, who is leaving this project at the end of May 2024. 

## Project purpose
The goal of this project is to make the pins site a place where students can browse for data, and where teachers can browse for data to leverage in their classes. Each dataset needs a script that builds the dataset and posts it to pins. Every dataset also needs a qmd to serve as the interface for the users to access the data. You can find more about the process by reading the instructions in the README in the main folder (data4_pins). 

## The spreadsheet in this folder
The spreadsheet in this folder was used by me to keep track of datasets with special considerations. It's not an exhaustive list, but it includes quite a few. It records the location / origin of each dataset, whether a script is necessary or not, and information about issues and errors. Green rows are datasets that don't need to be included. Green rows are datasets that have a completed script and qmd. Orange rows are datasets where the script is having an error. White rows haven't been finished, or it has not been decided whether they will get included in the pins site or not. 

Notice how in the dataset_locations_or_origin column, data is found in several different repositories and in Craig Johnson's onedrive. If you need to access any of those datasets and are having issues, you will need to ask Bro. Hathaway for access to any private repositories and Bro. Johnson for access to his onedrive (the onedrive is mainly useful because it contains word documents full of documentation for various MATH 221 datasets. It has extra data but we don't know if he wants any of them included in the pins site. Some are represented in the spreadsheet, with Bro. Johnson's comments summarized in the notes column. They're not super important to chase after. You'd have to ask. But you probably don't need it because by the time I leave, I should have added his documentation to every dataset that I have included thus far.).

Every dataset that has an incomplete script or qmd should be documented in the spreadsheet. Those were the issues I wasn't able to solve before leaving. 
If any data wrangling tasks aren't represented, it's because there's no need for a script. I didn't include all of those cases because it would have been a waste of time. I know this because I wasted a small amount of time including some of the data-less tasks. 

## RESOURCES
### Repositories used:
byuistats/data (MATH221 data, referred to in spreadsheet as byuistats repo)  
byuistats/M335 (Data wrangling and visualization's old course code was M335. This has data wrangling stuff in it. Also it's private.)  

byuidatascience/data4births   
byuidatascience/data4dwellings  
byuidatascience/data4marathons  
byuidatascience/data4missing  


### Packages used:
https://github.com/KSUDS/p2_hathaway_class/blob/main/parse_data.R (for gun deaths)  
https://github.com/hathawayj/buildings (for permits, which is used in the data wrangling Building the Past task)

Here is a link to all the data wrangling assignment instructions.  
https://byuistats.github.io/DS350_assignments/Task_01_set-up.html

There's also a private google drive called byuids_data. That's where we stick data that can't be read from anywhere else (like if the original website is too broken for R or Python to read, or if the data came from a package we no longer want to be dependent on). 


I hope this is useful to you! I can potentially be reached through the BYUI DSS slack (Elena West) if you find something weird that I failed to explain here. 

