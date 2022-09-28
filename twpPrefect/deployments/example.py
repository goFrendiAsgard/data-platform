from flows.example import main
from prefect.deployments import Deployment

deployment = Deployment.build_from_flow(
    flow=main,
    name='sample-flow',
    parameters={},
    infra_overrides={
        'env': {
            'PREFECT_API_URL': 'http://orion:4200/api',
            'PREFECT_LOGGING_LEVEL': 'INFO',
        }
    },
    path='/root',
    entrypoint='/root/flows/example.py:main',
    work_queue_name='my_queue',
)

if __name__ == '__main__':
    deployment.apply()