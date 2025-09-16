# Optimized PySpark Operations for Memory Efficiency
# Add these optimizations to your probe_universe function

def probe_universe_optimized(daily_df, stations_df, inv_agg_df,
                             tag="Optimized"):
    """
    Optimized version of probe_universe with memory-efficient operations
    """
    print(f"[{tag}] Starting optimized universe probe...")

    # OPTIMIZATION 1: Cache ID DataFrames immediately and force evaluation
    print(f"[{tag}] Caching ID DataFrames...")
    daily_ids = daily_df.select("ID").distinct().cache()
    station_ids = stations_df.select("ID").distinct().cache()
    inv_ids = inv_agg_df.select("ID").distinct().cache()

    # Force caching by triggering count operations
    daily_count = daily_ids.count()
    station_count = station_ids.count()
    inv_count = inv_ids.count()

    print(f"[{tag}] Cached: daily={daily_count}, station={station_count}, "
          f"inv={inv_count}")

    # OPTIMIZATION 2: Use broadcast joins for better memory efficiency
    from pyspark.sql.functions import broadcast

    # OPTIMIZATION 3: Compute differences with better memory management
    print(f"[{tag}] Computing set differences...")

    # Daily - Station
    diff1 = daily_ids.join(broadcast(station_ids), "ID", "left_anti").cache()
    diff1_count = diff1.count()
    print(f"[{tag}] Daily - Station: {diff1_count}")

    # Station - Daily
    diff2 = station_ids.join(broadcast(daily_ids), "ID", "left_anti").cache()
    diff2_count = diff2.count()
    print(f"[{tag}] Station - Daily: {diff2_count}")

    # Station - Inventory
    diff3 = station_ids.join(broadcast(inv_ids), "ID", "left_anti").cache()
    diff3_count = diff3.count()
    print(f"[{tag}] Station - Inventory: {diff3_count}")

    # Inventory - Daily
    diff4 = inv_ids.join(broadcast(daily_ids), "ID", "left_anti").cache()
    diff4_count = diff4.count()
    print(f"[{tag}] Inventory - Daily: {diff4_count}")

    # Clean up cached DataFrames
    daily_ids.unpersist()
    station_ids.unpersist()
    inv_ids.unpersist()
    diff1.unpersist()
    diff2.unpersist()
    diff3.unpersist()
    diff4.unpersist()

    print(f"[{tag}] Universe probe completed successfully")
    return {
        "daily_count": daily_count,
        "station_count": station_count,
        "inv_count": inv_count,
        "diffs": [diff1_count, diff2_count, diff3_count, diff4_count]
    }

# Usage in your notebook:
# result = probe_universe_optimized(daily, stations, inv_agg, tag="E-opt")
