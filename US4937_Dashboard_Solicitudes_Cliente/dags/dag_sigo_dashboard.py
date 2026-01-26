from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'consocio_senior',
    'depends_on_past': False,
    'start_date': datetime(2026, 1, 26),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'dag_sigo_dashboard_v1',
    default_args=default_args,
    description='Orquestación de Dashboard Solicitudes por Cliente US4937',
    schedule_interval=timedelta(hours=1), # Criterio: < 2 horas
    catchup=False,
) as dag:

    dbt_run = BashOperator(
        task_id='dbt_run_solicitudes',
        bash_command='cd /path/to/dbt/project && dbt run',
    )

    dbt_test = BashOperator(
        task_id='dbt_test_solicitudes',
        bash_command='cd /path/to/dbt/project && dbt test',
    )

    dbt_run >> dbt_test
