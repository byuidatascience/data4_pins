# packages
import pandas as pd
import gdown

# get and clean data
url = "https://drive.google.com/file/d/uc?id=1Ac5zPy_8UZnI8gxxsnBs-45D_ZOUZ1PQ/"
dat = gdown.download(url)

# dat = (pd.read_csv(url)
#     .query('~COMMUSE.notna()')
#     .drop(
#         columns = ['Model', 'Cluster', 'Group', 
#             'CondoComplex', 'CondoComplexName', 'COMMUSE'])
#     .assign(
#         NBHD = lambda x: x.NBHD.astype('object'))
#     .query('LIVEAREA > 0')
#     .set_index('PARCEL')
# )


# rename columns to lower case
dat.columns = dat.columns.str.lower()


dat.to_csv('../data/homes_denver.csv', index = True)
