# packages
import pandas as pd

# get and clean data
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


dat.to_csv('../data/homes_denver.csv', index = True)
