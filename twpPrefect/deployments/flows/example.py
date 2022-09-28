from prefect import flow, task, get_run_logger
from prefect.blocks.system import String
from prefect_airbyte.connections import trigger_sync as airbyte_trigger_sync


@task
def say_hello(name):
    logger = get_run_logger()
    hello = f"hello {name}"
    print(hello)
    logger.info(hello)


@task
def get_arguments(**kwargs):
    return kwargs


@flow(name="main flow")
async def main():
    logger = get_run_logger()
    airbyte_conn_id = await String.load("airbyte-mysql-postgre-connection-id")
    logger.info('run airbyte')
    await airbyte_trigger_sync(
        airbyte_server_host='host.docker.internal',
        airbyte_server_port='8021',
        connection_id=airbyte_conn_id.value,
        poll_interval_s=3,
        status_updates=True
    )
    logger.info('airbyte executed')

if __name__ == "__main__":
    main()
