# Data Script Details

1. Each script should start from a data source that is referencable. If your data isn't stored publicly online, create a space with the data that users of the Org can reference.
    - You can access the [Google Drive](https://drive.google.com/drive/u/0/folders/0AMnavGO2D6yoUk9PVA) by permission only for data too large for Github. See the Google Drive section below.
    - We should include a public link with the description if the data can be publicly posted.
2. The default file format should be `.parquet`.
    - Pedagogical purposes may demand a different format like `.json` or `.csv`.  Generally, we should avoid language-specific formats like `.rds` and `.pickle` for data.
    - Generally, we would always have a version that is `.parquet` and then create another _pin_ that is in `.json` or `.csv`
