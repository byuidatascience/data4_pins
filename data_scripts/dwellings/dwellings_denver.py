# packages
import pandas as pd
import pydrive2


# get and clean data
url = "https://drive.google.com/file/d/uc?id=1Ac5zPy_8UZnI8gxxsnBs-45D_ZOUZ1PQ/"



dat = (pd.read_csv(url)
    .query('~COMMUSE.notna()') # Filter nulls from commuse column
    .drop(
        columns = ['Model', 'Cluster', 'Group', 
            'CondoComplex', 'CondoComplexName', 'COMMUSE']) # drop these columns
    .assign(
        NBHD = lambda x: x.NBHD.astype('object')) # Convert 'NBHD' column to object type
    .query('LIVEAREA > 0') # Filter rows where 'LIVEAREA' is greater than 0
    .set_index('PARCEL') # Set 'PARCEL' column as the index
)


# rename columns to lower case
dat.columns = dat.columns.str.lower()


dat.to_csv('../data/homes_denver.csv', index = True)
