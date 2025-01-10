# https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-real-property-sales-book-2013
# https://github.com/abresler/realtR

# %%
# packages
import pandas as pd
import numpy as np

# %%
url = "https://www.denvergov.org/media/gis/DataCatalog/real_property_sales_book_2013/csv/SalesBook_2013.csv"
dat = (pd.read_csv(url)
    .query('~COMMUSE.notna()')
    .drop(
        columns = ['Model', 'Cluster', 'Group', 
            'CondoComplex', 'CondoComplexName', 'COMMUSE'])
    .assign(
        NBHD = lambda x: x.NBHD.astype('object'))
    .query('LIVEAREA > 0')
    .set_index('PARCEL')
)




# rename columns to lower case
dat.columns = dat.columns.str.lower()

dat_ml = (pd.get_dummies(dat
    .drop(
        columns = ['nbhd', 'floorlvl', 'xtraffic']))
    .assign(
        before1980 = lambda x: x.yrbuilt < 1980)
    .assign(
        before1980 = lambda x: x.before1980.astype(int))
)

# %%

dat_ml.to_csv('../data/homes_denver_ml.csv', index = True)

# %%