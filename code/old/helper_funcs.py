# helper_funcs.py
# ------------------------------------------------------------------
# Pure Spark helpers used by the original Assignment 1 notebook.
# These functions DO NOT start/stop Spark. They assume the notebook
# already created a SparkSession and the input DataFrames.
# ------------------------------------------------------------------

from typing import Dict, Tuple, Optional
from pyspark.sql import DataFrame, functions as F

# ---------- Generic summaries ----------

def summarize_core_elements(daily_df: DataFrame) -> DataFrame:
    # Count observations for TMAX, TMIN, PRCP, SNOW, SNWD
    core = ("TMAX", "TMIN", "PRCP", "SNOW", "SNWD")
    return (daily_df
            .where(F.col("ELEMENT").isin(core))
            .groupBy("ELEMENT").count()
            .orderBy("ELEMENT"))

def count_daily_rows(daily_df: DataFrame) -> int:
    # Return total number of rows in the daily dataset.
    return daily_df.count()

def count_total_stations(stations_df: DataFrame) -> int:
    # Return total number of distinct stations (by ID).
    return stations_df.select("ID").distinct().count()

def count_active_stations_in_year(daily_df: DataFrame, year: int) -> int:
    # Count stations that have at least one observation in the given year.
    # Assumes DATE is a string like 'YYYYMMDD' or an int like 20250131.
    df = daily_df
    if "DATE" not in df.columns:
        raise ValueError("Expected a DATE column in daily_df")
    dtmap = dict(df.dtypes)
    if dtmap["DATE"] in ("string", "varchar"):
        df = df.withColumn("YEAR", F.substring("DATE", 1, 4).cast("int"))
    else:
        df = df.withColumn("YEAR", (F.col("DATE")/10000).cast("int"))
    return (df.where(F.col("YEAR") == F.lit(year))
              .select("ID").distinct().count())

def count_tmax_without_tmin_same_day(daily_df: DataFrame) -> int:
    # Number of (station, date) pairs with a TMAX record but no corresponding TMIN.
    tmax = (daily_df.where(F.col("ELEMENT") == "TMAX")
                   .select(F.col("ID").alias("ID_t"), F.col("DATE").alias("DATE_t"))
                   .dropDuplicates())
    tmin = (daily_df.where(F.col("ELEMENT") == "TMIN")
                   .select(F.col("ID").alias("ID_n"), F.col("DATE").alias("DATE_n"))
                   .dropDuplicates())
    joined = (tmax.join(tmin,
                        (tmax.ID_t == tmin.ID_n) & (tmax.DATE_t == tmin.DATE_n),
                        "left")
                   .where(F.col("ID_n").isNull()))
    return joined.count()

# ---------- Enrichment helpers ----------

def enrich_stations(stations_df: DataFrame,
                    states_df: Optional[DataFrame],
                    countries_df: DataFrame,
                    inventory_df: Optional[DataFrame] = None) -> DataFrame:
    # Join stations with countries (and optionally states, inventory).
    s = stations_df
    c = countries_df

    s_key = "COUNTRY" if "COUNTRY" in s.columns else ("CTRY" if "CTRY" in s.columns else None)
    c_key = "COUNTRY" if "COUNTRY" in c.columns else ("FIPS" if "FIPS" in c.columns else None)

    if s_key and c_key:
        s = (s.join(c.select(F.col(c_key).alias("_ck"),
                             *[x for x in c.columns if x != c_key]),
                    s[s_key] == F.col("_ck"), "left")
               .drop("_ck"))

    if states_df is not None and "STATE" in s.columns and "STATE" in states_df.columns:
        st = states_df.select(F.col("STATE").alias("_sk"),
                              *[x for x in states_df.columns if x != "STATE"])
        s = s.join(st, s["STATE"] == F.col("_sk"), "left").drop("_sk")

    if inventory_df is not None and "ID" in s.columns and "ID" in inventory_df.columns:
        inv_counts = (inventory_df.groupBy("ID", "ELEMENT").count()
                                   .groupBy("ID").pivot("ELEMENT").sum("count"))
        s = s.join(inv_counts, "ID", "left")

    return s

# ---------- Geodesic helpers ----------

def haversine_km(lat1, lon1, lat2, lon2):
    # Return great-circle distance in km between two points (in degrees).
    rad = F.lit(0.017453292519943295)  # pi/180
    dlat = (lat2 - lat1) * rad
    dlon = (lon2 - lon1) * rad
    a = (F.sin(dlat/2)**2
         + F.cos(lat1*rad)*F.cos(lat2*rad)*F.sin(dlon/2)**2)
    return F.lit(12742.0) * F.asin(F.sqrt(a))  # 2*R, R≈6371km

def closest_pair_in_country(enriched_stations: DataFrame,
                            country_code: str = "NZ") -> Tuple[str, str, float]:
    # Brute‑force closest station pair within a given COUNTRY code.
    # Returns (ID1, ID2, distance_km). Suitable for small countries like NZ.
    s = (enriched_stations
         .where(F.col("COUNTRY") == country_code)
         .select("ID", "LATITUDE", "LONGITUDE")
         .dropna())
    a = s.alias("a")
    b = s.alias("b")
    pair = (a.join(b, F.col("a.ID") < F.col("b.ID"))
              .withColumn("dist_km",
                          haversine_km(F.col("a.LATITUDE"), F.col("a.LONGITUDE"),
                                       F.col("b.LATITUDE"), F.col("b.LONGITUDE")))
              .orderBy(F.col("dist_km").asc())
              .limit(1)
              .collect())
    if not pair:
        return ("", "", float("nan"))
    row = pair[0]
    return (row["a.ID"], row["b.ID"], float(row["dist_km"]))

# ---------- Pretty printing ----------

def dict_to_html(d: Dict) -> str:
    # Convert a Python dict into a 2‑column HTML table for display.
    rows = [f"<tr><td style='padding:2px 8px; font-family:monospace'>{k}</td>"
            f"<td style='padding:2px 8px; font-family:monospace'>{v}</td></tr>"
            for k, v in d.items()]
    return "<table>" + "".join(rows) + "</table>"
