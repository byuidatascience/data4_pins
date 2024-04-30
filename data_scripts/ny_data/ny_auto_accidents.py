# %%
import polars as pl
import pins
# %%
dat = pl.read_csv("Motor_Vehicle_Collisions_-_Crashes_20240124.csv")\
    .with_columns(
        pl.col("CRASH DATE").str.to_date("%m/%d/%Y").alias("date"),
        pl.col("CRASH TIME").str.to_time("%H:%M").alias("time"),
        pl.concat_str(["CRASH DATE","CRASH TIME"], separator=" ")\
            .str.to_datetime("%m/%d/%Y %H:%M").alias("date_time"))

dat.write_parquet("ny_crashes.parquet", compression="zstd", compression_level=15)
# %%
dat = pl.read_parquet("ny_crashes.parquet")
# %%

hourly_dat = dat.with_columns(pl.col("date_time").dt.truncate("1h").alias("date_hour"))\
    .group_by("date_hour").agg(
        pl.col("date_hour").count().alias("accidents"),
        pl.col("NUMBER OF PERSONS INJURED").sum().alias("injured_total"),
        pl.col("NUMBER OF MOTORIST INJURED").sum().alias("insured_motorist"),
    ).sort("date_hour")\
    .with_columns(
        pl.col("date_hour").dt.year().alias("year"),
        pl.col("date_hour").dt.month().alias("month"),
        pl.col("date_hour").dt.day().alias("day"),
        pl.col("date_hour").dt.hour().alias("hour"),
    )


