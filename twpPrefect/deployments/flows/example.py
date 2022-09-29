from prefect import flow, task, get_run_logger
from prefect.blocks.system import String
from prefect.blocks.system import JSON

from prefect_airbyte.connections import trigger_sync as trigger_airbyte_sync
from prefect_dbt.cli.commands import trigger_dbt_cli_command
from prefect_dbt.cli import DbtCliProfile
from prefect_dbt.cli.configs import PostgresTargetConfigs
from prefect_sqlalchemy import DatabaseCredentials, SyncDriver


@flow(name="main flow")
def main():
    logger = get_run_logger()

    # you can set the configurations here: http://localhost:4200/blocks
    airbyte_conn_id = String.load("airbyte-mysql-postgre-connection-id")
    postgres_connection = JSON.load("postgres-connection")
    
    logger.info('trigger airbyte sync')
    trigger_airbyte_sync(
        airbyte_server_host='host.docker.internal',
        airbyte_server_port='8021',
        connection_id=airbyte_conn_id.value,
        poll_interval_s=3,
        status_updates=True,
        timeout=60
    )
    logger.info('airbyte sync executed')

    logger.info('get postgres profile')
    credentials = DatabaseCredentials(
        driver=SyncDriver.POSTGRESQL_PSYCOPG2,
        username=postgres_connection.value['POSTGRES_USER'],
        password=postgres_connection.value['POSTGRES_PASS'],
        database=postgres_connection.value['POSTGRES_DBNAME'],
        host=postgres_connection.value['POSTGRES_HOST'],
        port=5432
    )
    target_configs = PostgresTargetConfigs(credentials=credentials, schema=postgres_connection.value['POSTGRES_SCHEMA'])
    dbt_cli_profile = DbtCliProfile(
        name="dbt_sample",
        target="default",
        target_configs=target_configs,
    )
    project_dir = '/root/flows/dbt_sample'
    logger.info('dbt deps')
    trigger_dbt_cli_command("dbt deps", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)
    logger.info('dbt run')
    trigger_dbt_cli_command("dbt run", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)
    logger.info('dbt test')
    trigger_dbt_cli_command("dbt test", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)

if __name__ == "__main__":
    main()
