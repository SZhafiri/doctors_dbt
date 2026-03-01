import pandas as pd
from sqlalchemy import create_engine, text

engine = create_engine('postgresql://airflow:airflow@postgres:5432/airflow')

dentist_csv = '/opt/airflow/dags/data/dentist_raw.csv'
practice_csv = '/opt/airflow/dags/data/practice_place_raw.csv'

def ingest_data():
    print("Reading CSV files...")
    df_dentists = pd.read_csv(dentist_csv)
    df_practices = pd.read_csv(practice_csv)

    print("Clearing out old tables and dbt views...")
    with engine.begin() as conn:
        conn.execute(text("DROP TABLE IF EXISTS raw_dentist CASCADE;"))
        conn.execute(text("DROP TABLE IF EXISTS raw_practice_place CASCADE;"))

    print("Loading data into PostgreSQL...")
    df_dentists.to_sql('raw_dentist', engine, if_exists='replace', index=False)
    df_practices.to_sql('raw_practice_place', engine, if_exists='replace', index=False)
    
    print("Success! Data is ready for dbt.")

if __name__ == "__main__":
    ingest_data()