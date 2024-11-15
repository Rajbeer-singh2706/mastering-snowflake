-- from Query History
with PYTHON_WORKSHEET as procedure ()
    returns Table()
    language python
    runtime_version=3.11
    packages=('snowflake-snowpark-python')
    handler='main'
as 'import snowflake.snowpark as snowpark

def main(session: snowpark.Session):
    df = session.table(''SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM'')
    df = df.dropDuplicates()
    df.write.mode("overwrite").save_as_table("LINEITEM_SNOWPARK")
    return df'

call PYTHON_WORKSHEET();