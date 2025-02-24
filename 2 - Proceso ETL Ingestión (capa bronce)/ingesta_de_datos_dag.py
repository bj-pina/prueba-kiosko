from airflow import DAG
from airflow.providers.microsoft.azure.operators.azure_functions import AzureFunctionInvokeFunctionOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 2, 22),
    "email_on_failure": True,
    "email_on_retry": True,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Se configura el DAG para ejecutar cada semana el día lunes a las 12:00 am
with DAG(
    dag_id='ingestion_SYP_500_files',
    default_args=default_args,
    schedule_interval='0 0 * * MON',  
    catchup=False,
) as dag:
    execute_function = AzureFunctionInvokeFunctionOperator(
        task_id='invoke_azure_function',
        function_name='ingesta_de_datos', 
        azure_function_conn_id='connection_id', 
        payload={}, 
    )