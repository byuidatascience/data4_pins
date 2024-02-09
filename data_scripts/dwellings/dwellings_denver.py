# packages
import pandas as pd
from pydrive2.drive import GoogleDrive
from pydrive2.auth import GoogleAuth
from io import StringIO, BytesIO



# get and clean data
url = "https://drive.google.com/file/d/1i0ASVFW9t_oUpwD0gGoqabRakDQrWttY/view?usp=drive_link"

# Set the drive to an authentication object with access to target account.
drive = GoogleDrive(GoogleAuth)


# Parse URL.
file_id = url.split('/')[2]

file = drive.CreateFile({'id':file_id})

# ????!!?!?!
# buffer = file.GetContentIOBuffer()

dat = (pd.read_csv(file.read_csv())
    .query('~COMMUSE.notna()') # Filter nulls from commuse column
    .drop(
        columns = ['Model', 'Cluster', 'Group', 
            'CondoComplex', 'CondoComplexName', 'COMMUSE']) # drop these columns
    .assign(
        NBHD = lambda x: x.NBHD.astype('object')) # Convert 'NBHD' column to object type
    .query('LIVEAREA > 0') # Filter rows where 'LIVEAREA' is greater than 0
    .set_index('PARCEL') # Set 'PARCEL' column as the index
)


# # rename columns to lower case
# dat.columns = dat.columns.str.lower()


# dat.to_csv('../data/homes_denver.csv', index = True)
