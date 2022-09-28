# Demo untuk Tekno Bareng Peter

Pada repositori ini ada beberapa komponen yang umum dipakai dalam data engineering:

- App
    - Port [3000](http://localhost:3000)
- OLTP: MySQL
    - Port 3306
- Messaging/Event Streaming: Kafka
    - Port 9092 (from localhost)
    - Port 39092 (from other container)
    - Port 2181 (zookeeper)
    - Port 9101 (JMX)
    - Port 8083 (kafka connect, not used)
    - Port [9021](http://localhost:9021) (control center)
    - Port 8088 (KSQL, not used)
    - Port 8082 (REST proxy, not used)
- Orchestrator: Prefect
    - Port [4200](http://localhost:4200) (Orion)
- ETL/ELT: Airbyte
    - Port 8021
    - Port [8020](http://localhost:8020) (UI)
    - Port 7233 (Temporal)
- Streaming: Materialize
    - Port: 6875
- OLAP/Data warehouse: ClickHouse (Currently failed to connect to Metabase, not used, see [this issue](https://github.com/enqueue/metabase-clickhouse-driver/issues/101))
    - Port: 9000
    - Port: [8123](http://localhost:8123/play) (UI)
- OLAP/Data warehouse: Postgresql
    - Port: 5432
- Analytics Dashboard: Metabase
    - Port: [3001](http://localhost:3001)
    - User: gofrendiasgard@gmail.com
    - Password: Alch3mist


# Airbyte connection ID

Saat membuka salah satu connection di airbyte, kita akan menemukan URL seperti berikut:

```
http://localhost:8020/workspaces/ded7dd9d-62e2-4d54-b7ff-a4fe51834b20/connections/290db93e-2786-4f50-ae71-35f8ff7ad6b4/status
```

Dalam hal ini, connection ID dari connection tersebut adalah `290db93e-2786-4f50-ae71-35f8ff7ad6b4`

# Register TWP Prefect flows

```bash
zaruba please registerTwpPrefectFlow
```

# Create DBT project

```bash
cd twpPrefect/deployments
source venv/bin/activate
pip install dbt-postgres
cd flows
dbt init dbt_sample
```

# Run DBT locally

```bash
cd twpPrefect/deployments
source venv/bin/activate
cd flows/dbt_sample
source dbt.env
dbt deps
dbt run && dbt test
```

# Materialize

```sql
CREATE SOURCE view_json_source
FROM KAFKA BROKER 'host.docker.internal:39092' TOPIC 'view_content' WITH (client_id='id_coba', group_id_prefix='group_coba')
FORMAT BYTES;
  
CREATE VIEW raw_view_content AS
  SELECT
    (data->>'session_id')::varchar AS session_id
    , (data->>'content_id')::varchar AS content_id
    , (data->>'user_id')::varchar AS user_id
    , (data->>'created_at') AS created_at
  FROM (SELECT CONVERT_FROM(data, 'utf8')::jsonb AS data FROM view_json_source);

CREATE MATERIALIZED VIEW view_content AS
  SELECT *
  FROM raw_view_content;

SELECT * FROM view_content;

SELECT
	view_content.*
	, view_content.created_at::timestamp
	, mz_logical_timestamp()
	, to_timestamp(mz_logical_timestamp()/1000)  at time zone 'UTC' + interval '-20 seconds' as twenty_seconds_ago 
FROM view_content;


CREATE VIEW current_view_content AS
    SELECT 
        count(distinct session_id) global_view_count
        , content_id
    FROM view_content
    WHERE view_content.created_at::timestamp > to_timestamp(mz_logical_timestamp()/1000)  at time zone 'UTC' + interval '-1 days'
    GROUP BY content_id;

SELECT * FROM current_view_content;
		

--drop view view_content;
--drop view raw_view_content;
--drop source view_json_source;
--
--show sources;
```