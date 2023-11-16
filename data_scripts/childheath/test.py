# %%
import os
from pins import board_rsconnect
from dotenv import load_dotenv
load_dotenv()
API_KEY = os.getenv('CONNECT_API_KEY')
SERVER = os.getenv('CONNECT_SERVER')

board = board_rsconnect(server_url=SERVER, api_key=API_KEY)
dat = board.pin_read("hathawayj/birth_us")
# %%
import pyarrow as pa
import pyarrow.parquet as pq

pq.read_table("https://posit.byui.edu/data/days_365/days_365.parquet")
# %%
import pyarrow.parquet as pq
from io import BytesIO
import requests

def read_parquet_from_url(url):
    # Make a GET request to the URL to get the Parquet file content
    response = requests.get(url)
    
    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Read the Parquet file content from the response
        parquet_content = BytesIO(response.content)
        
        # Use PyArrow to read the Parquet file from the BytesIO object
        table = pq.read_table(parquet_content)
        
        # Optionally, you can convert the PyArrow Table to a Pandas DataFrame
        # pandas_dataframe = table.to_pandas()
        
        return table.to_pandas()
    else:
        # Print an error message if the request was not successful
        print(f"Failed to retrieve data. Status code: {response.status_code}")
        return None

# Example usage:
url = "https://posit.byui.edu/data/days_365/days_365.parquet"
parquet_table = read_parquet_from_url(url)
# %%
import pandas as pd
import requests
from io import BytesIO

def read_board_url(url):
    response = requests.get(url)
    if response.status_code == 200:
        parquet_content = BytesIO(response.content)
        pandas_dataframe = pd.read_parquet(parquet_content)
        return pandas_dataframe
    else:
        print(f"Failed to retrieve data. Status code: {response.status_code}")
        return None

# Example usage:
url = "https://posit.byui.edu/data/days_365/days_365.parquet"
pandas_df = read_parquet_from_url_with_pandas(url)
# %%
