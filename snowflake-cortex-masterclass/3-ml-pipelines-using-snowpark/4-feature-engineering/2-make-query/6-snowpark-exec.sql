-- from Query History (filter by QUERY_TAG=snowpark_queries)
CREATE OR REPLACE TABLE HOUSING_SNOWPARK(
    "OCEAN_PROXIMITY" STRING(16777216),
    "AVG_HOUSEHOLDS" NUMBER(38, 7))
AS SELECT * FROM (
    SELECT * FROM (
        SELECT "OCEAN_PROXIMITY", avg("HOUSEHOLDS") AS "AVG_HOUSEHOLDS"
        FROM (
            SELECT "HOUSING_MEDIAN_AGE", "TOTAL_ROOMS", "TOTAL_BEDROOMS", "HOUSEHOLDS", "OCEAN_PROXIMITY"
            FROM HOUSING
            WHERE "OCEAN_PROXIMITY" IN ('INLAND', 'ISLAND', 'NEAR BAY'))
        GROUP BY "OCEAN_PROXIMITY")
    ORDER BY "AVG_HOUSEHOLDS" ASC NULLS FIRST);

select system$cancel_all_queries(24153001993487742);