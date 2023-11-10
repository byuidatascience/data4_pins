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
