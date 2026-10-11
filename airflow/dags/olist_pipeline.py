from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

PROJECT = "/opt/airflow/project1"
DBT = "/home/airflow/dbt_venv/bin/dbt"
DBT_ARGS = f"--project-dir {PROJECT}/olist_warehouse --profiles-dir {PROJECT}/olist_warehouse"

with DAG(
    dag_id="olist_warehouse_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["project1", "olist"],
) as dag:

    load_staging = BashOperator(
        task_id="load_staging",
        bash_command=f"python {PROJECT}/load_staging.py",
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"{DBT} run {DBT_ARGS}",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"{DBT} test {DBT_ARGS}",
    )

    load_staging >> dbt_run >> dbt_test
    