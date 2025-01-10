# https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-real-property-sales-book-2013
# https://github.com/abresler/realtR

# %%
# packages
import polars as pl
import os
from dotenv import load_dotenv, find_dotenv
from pins import board_connect
import http.cookiejar
import json
import os
import urllib.parse
import urllib.request
from pydrive2.auth import GoogleAuth
from oauth2client.service_account import ServiceAccountCredentials
from pydrive2.drive import GoogleDrive

load_dotenv("../../../../.env")
API_KEY = os.getenv('CONNECT_API_KEY')
SERVER = os.getenv('CONNECT_SERVER')
# %%
SCOPES = ['https://www.googleapis.com/auth/drive.readonly']
gauth = GoogleAuth()
gauth.credentials = ServiceAccountCredentials.from_json("client_secrets.json", SCOPES)

# %%
gauth.LocalWebserverAuth()

drive = GoogleDrive(gauth)


# %%
dat = pl.read_csv(url, ignore_errors=True, truncate_ragged_lines=True)\
  .filter((pl.col("COMMUSE").is_null()) & (pl.col("LIVEAREA") > 0))\
  .drop(['Model', 'Cluster', 'Group', 'CondoComplex', 'CondoComplexName', 'COMMUSE'])\
  .with_columns(pl.col("NBHD").cast(pl.String()).cast(pl.Categorical()))\
  .select(pl.all().name.to_lowercase())

#%%
datp = pd.read_csv(url)\
    .query('~COMMUSE.notna()')\
    .drop(columns = ['Model', 'Cluster', 'Group', 'CondoComplex', 'CondoComplexName', 'COMMUSE'])\
    .assign(NBHD = lambda x: x.NBHD.astype('object'))\
    .query('LIVEAREA > 0')

# need to move the index into a column
# Here is the API to change the vanity name https://posit.co/blog/rstudio-connect-1-8-6-server-api/
# rename columns to lower case
dat.columns = dat.columns.str.lower()

# %%

# Publish the data to the server with Bro. Hathaway as the owner.
pin_name = "dwellings_denver"
board = board_connect(server_url=SERVER, api_key=API_KEY)
board.pin_write(dat.to_pandas(), "hathawayj/" + pin_name, type="parquet")

# %%
meta = board.pin_meta("hathawayj/" + pin_name)
# https://docs.posit.co/connect/user/python-pins/
# https://rstudio.github.io/pins-python/
meta.local.get("content_id")



#%% R code
# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, led_study, type = "parquet")

pin_name <- "led_study"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))