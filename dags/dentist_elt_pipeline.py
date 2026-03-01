import pendulum
from datetime import datetime
from airflow.sdk import dag
from airflow.providers.standard.operators.bash import BashOperator

DBT_DIR = "/opt/airflow/dags/dbt_dentist"

@dag(
    dag_id='dentist_end_to_end_elt',
    start_date=pendulum.datetime(2025, 5, 3, tz='Asia/Jakarta'),
    schedule='0 1 4 5 *',
    catchup=False,
    tags=['ingestion', 'dbt', 'dentist'],
)
def dentist_elt_pipeline():
    
    # Task 1 Data Ingestion
    ingest_data = BashOperator(
        task_id='ingest_csv_to_postgres',
        bash_command='python /opt/airflow/dags/ingest_data.py'
    )

    # Task 2 Check dbt connection
    test_dbt = BashOperator(
        task_id='dbt_debug',
        bash_command=f"dbt debug --project-dir {DBT_DIR} --profiles-dir {DBT_DIR}"
    )

    # Task 3 Staging
    run_staging = BashOperator(
        task_id='dbt_run_staging',
        bash_command=f"dbt run --select staging --project-dir {DBT_DIR} --profiles-dir {DBT_DIR}"
    )

    # Task 4 Data Mart
    run_mart = BashOperator(
        task_id='dbt_run_mart',
        bash_command=f"dbt run --select mart --project-dir {DBT_DIR} --profiles-dir {DBT_DIR}"
    )

    ingest_data >> test_dbt >> run_staging >> run_mart

dentist_elt_pipeline()