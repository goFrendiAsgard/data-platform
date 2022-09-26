# Demo untuk Tekno Bareng Peter

Pada repositori ini ada beberapa komponen yang umum dipakai dalam data engineering:

- OLTP: MySQL
    - Port 3306
- Messaging/Event Streaming: Kafka
    - Port 9092
    - Port 2181 (zookeeper)
    - Port 9101 (JMX)
    - Port 8083 (kafka connect)
    - Port 9021 ([control center](http://localhost:9021))
    - Port 8088 (KSQL)
    - Port 8082 (REST proxy)
- Orchestrator: Prefect
    - Port 4200 ([Orion](http://localhost:4200))
- ETL/ELT: Airbyte
    - Port 8021
    - Port 8020 ([UI](http://localhost:8020))
    - Port 7233 (Temporal)
- Streaming: Materialize
    - Port: 6875
- OLAP/Data warehouse: ClickHouse
    - Port: 8123
    - Port: 9000 ([UI](http://localhost:9000))
- Analytics Dashboard: Metabase