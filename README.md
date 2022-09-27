# Demo untuk Tekno Bareng Peter

Pada repositori ini ada beberapa komponen yang umum dipakai dalam data engineering:

- App
    - Port [3000](http://localhost:3000)
- OLTP: MySQL
    - Port 3306
- Messaging/Event Streaming: Kafka
    - Port 9092
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
- OLAP/Data warehouse: ClickHouse
    - Port: 9000
    - Port: [8123](http://localhost:8123/play) (UI)
- Analytics Dashboard: Metabase
    - Port: [3001](http://localhost:3001)