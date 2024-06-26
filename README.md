# BYU-I Course Project Data 

We use two primary sources to manage and share course project data. 1) pins at posit.byui.edu and 2) the data blog at XXXX.  Each blog post represents a description of a data set. This repository contains the derivation scripts that generate the data.

## posit.byui.edu


## Data blog

## Data generation scripts


## File size

> An important factor in determining whether or not to use a pin is the size of the data or object in use. As a general rule of thumb, __we don’t recommend using pins with files over 500 MB__. If you find yourself routinely pinning data larger than this, then you might need to reconsider your data engineering pipeline. [Reference](https://docs.posit.co/connect/user/python-pins/#:~:text=The%20Python%20pins%20library%20provides,you%20use%20to%20share%20data.)


## How to pin a new dataset

Each dataset needs 1) a script that will read the data from its source and 2) a QMD that provides the interface for those who access the data. 

### The script

The script should be a self-contained R script that will  
1) load in the libraries that it requires  
2) read in the data from its source  
Paste in the link to the data file, or put in the code that will retrieve it.  
3) perform any necessary wrangling  
Get the data into whatever shape is best.
4) post the data to pins.  
All you have to change is the dataset_name - make it match the object that now contains your data.

See the _template_script.R File in XXXX for a template.  



### The QMD

The QMD reads the script you made for your dataset and allows a user to download the data. It also needs to contain a dictionary to explain the nature of the dataset's columns. See the _template.qmd file in XXXX for a template. The things you need to do include 
1) Change the general information in the YAML (the text between two "---" dashes - it defines a few parameters for the rest of the document), including the categories by which your dataset will be searchable. 
2) Replace 'SOME TYPE OF DATA DICTIONARY' with a data dictionary. Please use this format:

\- \_\_column1name:\_\_ Description of the first column (unit)  
\- \_\_column2name:\_\_ Description of the second column (unit)  
\- \_\_column3name:\_\_ Description of the third column (unit)  

In QMDs, you make text bold by \_\_surrounding it with underscores\_\_, and use "-" to create a bulleted list. 

3) Locate the two commented out chunks of code. One should be labelled as R, the other should be labelled as Python. If your script is in R, uncomment the R chunk. If your script is in Python, uncomment the Python chunk. Change 'YOURFILEPATH' to the file path of your script.

