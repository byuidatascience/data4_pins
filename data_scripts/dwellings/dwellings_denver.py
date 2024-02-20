# packages
from typing import Union, Dict
from io import BytesIO, StringIO
import json
import pandas as pd
import requests
from pydrive2.auth import GoogleAuth
from pydrive2.drive import GoogleDrive

def read_private_file_from_gdrive(
    file_url: str, file_format: str, google_auth: GoogleAuth, **kwargs
) -> Union[pd.DataFrame, Dict, str]:
    """Read private files from Google Drive.
    Parameters
    ----------
    file_url : str
        URL adress to file in Google Drive.
    file_format : str
        File format can be 'csv', 'xlsx', 'parquet', 'json' or 'txt'.
    google_auth: GoogleAuth
        Google Authentication object with access to target account. For more
        information on how to login using Auth2, please check the link below:
        https://docs.iterative.ai/PyDrive2/quickstart/#authentication
    Returns
    -------
    Union[pd.DataFrame, Dict, str].
        The specified object generate from target file.
    """
    drive = GoogleDrive(google_auth)

    # Parsing file URL
    file_id = file_url.split("/")[-2]

    file = drive.CreateFile({"id": file_id})

    content_io_buffer = file.GetContentIOBuffer()

    if file_format == "csv":
        return pd.read_csv(
            StringIO(content_io_buffer.read().decode()), **kwargs
        )

    # elif file_format == "xlsx":
    #     return pd.read_excel(content_io_buffer.read(), **kwargs)

    # elif file_format == "parquet":
    #     byte_stream = content_io_buffer.read()
    #     return pd.read_parquet(BytesIO(byte_stream), **kwargs)

    # elif file_format == "json":
    #     return json.load(StringIO(content_io_buffer.read().decode()))

    # elif file_format == "txt":
    #     byte_stream = content_io_buffer.read()
    #     return byte_stream.decode("utf-8", **kwargs)



# get and clean data
url = "https://drive.google.com/file/d/1i0ASVFW9t_oUpwD0gGoqabRakDQrWttY/view?usp=drive_link"

# Call the above function to read this csv into a pd dataframe
dat = read_private_file_from_gdrive(url, 'csv', GoogleAuth())







# Set the drive to an authentication object with access to target account.
# drive = GoogleDrive(GoogleAuth())

# # Parse URL.
# file_id = url.split('/')[2]

# file = drive.CreateFile({'id':file_id})

# # ????!!?!?!
# buffer = file.GetContentIOBuffer()

# pd.read_csv(
#     StringIO(file.GetContentString())
# )

# dat = (pd.read_csv(file.read_csv())
#     .query('~COMMUSE.notna()') # Filter nulls from commuse column
#     .drop(
#         columns = ['Model', 'Cluster', 'Group', 
#             'CondoComplex', 'CondoComplexName', 'COMMUSE']) # drop these columns
#     .assign(
#         NBHD = lambda x: x.NBHD.astype('object')) # Convert 'NBHD' column to object type
#     .query('LIVEAREA > 0') # Filter rows where 'LIVEAREA' is greater than 0
#     .set_index('PARCEL') # Set 'PARCEL' column as the index
# )


# # rename columns to lower case
# dat.columns = dat.columns.str.lower()


# dat.to_csv('../data/homes_denver.csv', index = True)
