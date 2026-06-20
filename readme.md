# db-playground

> Setup any database playground with sample data in seconds

The repository has a simple docker-compose file and a few scripts to set up any database playground with sample data in
seconds. It is a great way to test your database queries and learn about the database.

You can run a single command to setup [Northwind](https://en.wikiversity.org/wiki/Database_Examples/Northwind) dataset in PostgreSQL, MySQL, MariaDB, MongoDB, SQLite, SQL Server, DuckDB, DynamoDB, CockroachDB, Cassandra and some sample indexes (omdb and shakespeare) in Elasticsearch.

## Usage

Make sure you have [Docker](https://docs.docker.com/get-docker/) installed and running.

After that, you can clone the repository and run any of the available services either using `Makefile` or `playground.sh` script.

### Using Makefile

To spin up any of the services, run any of the below commands in a terminal

```shell
# run any of the below commands to start the relevant service
make postgres
make mysql
make mariadb
make mongo
make elasticsearch
make redis
make sqlite
make sqlserver
make duckdb
make dynamodb
make cockroachdb
make cassandra
```

Once the service is up, you can run the below command in another terminal to connect to the service
```shell
make postgres-cli
make mysql-cli
make mariadb-cli
make mongo-cli
make elasticsearch-cli
make redis-cli
make sqlite-cli
make sqlserver-cli
make duckdb-cli
make dynamodb-cli
make cockroachdb-cli
make cassandra-cli
```

### Using playground.sh

```shell
# See what you can do with playground
./playground.sh -h

# run all the services using one of the following
./playground.sh
./playground.sh -s all

# run a single service
./playground.sh -s mongo
./playground.sh -s mysql
./playground.sh -s mariadb
./playground.sh -s posgres
./playground.sh -s elasticsearch
./playground.sh -s redis
./playground.sh -s sqlite
./playground.sh -s sqlserver
./playground.sh -s duckdb
./playground.sh -s dynamodb
./playground.sh -s cockroachdb
./playground.sh -s cassandra

# clean up the playground
./playground.sh -c

# clean up the playground and run the services
./playground.sh -c -s all
./playground.sh -c -s mongo
./playground.sh -c -s postgres
./playground.sh -c -s elasticsearch
./playground.sh -c -s redis
./playground.sh -c -s mysql
./playground.sh -c -s mariadb
./playground.sh -c -s sqlite
./playground.sh -c -s sqlserver
./playground.sh -c -s duckdb
./playground.sh -c -s dynamodb
./playground.sh -c -s cockroachdb
./playground.sh -c -s cassandra
```

You can also ue the `docker-compose` command directly to run the services.

```shell
# run all the services
docker-compose up -d

# run a single service
docker-compose up -d mongo

# clean up the playground
docker-compose down
```

## Database Credentials

Given below are the default configuration for the databases.

### PostgreSQL

Following are the details to connect to the database

```text
Host:     localhost
Port:     6432
Username: admin
Password: admin
Database: northwind
```
You can use the following command to run commands on the database
```bash
docker exec -it db_playground_postgres psql -U admin -d northwind
```

### MySQL

Following are the details to connect to the database

```text
Host:     localhost
Port:     4306
Username: admin
Password: admin
Database: northwind
```
You can use the following command to run commands on the database
```bash
docker exec -it db_playground_mysql mysql -uadmin -padmin
```

### MariaDB

Following are the details to connect to the database

```text
Host:     localhost
Port:     4307
Username: admin
Password: admin
Database: northwind
```
You can use the following command to run commands on the database
```bash
docker exec -it db_playground_mariadb mariadb -uadmin -padmin
```

## MongoDB

Following are the details to connect to MongoDB

```text
Host:     localhost
Port:     37017
Database: northwind
```

You can use the following command to run commands on the database

```bash
docker exec -it db_playground_mongo mongosh
```

## Elasticsearch

Following are the details to connect to Elasticsearch

```text
Host:     localhost
Port:     9200
Indexes:  omdb, shakespear
```

You can use the following command to run commands on the container

```bash
docker exec -it db_playground_elasticsearch sh
```

## Redis

Following are the details to connect to Redis

```text
Host:     localhost
Port:     6379
```

You can use the following command to run commands on the container

```bash
docker exec -it db_playground_redis redis-cli
```

## SQLite

SQLite is embedded, so there is no host or port. The container is seeded with the Northwind dataset and the database file is also mounted to `./sqlite/data/northwind.db` on the host, so you can open it with any local SQLite client.

```text
Database: /data/northwind.db (inside the container)
File:     ./sqlite/data/northwind.db (on the host)
Dataset:  northwind
```

You can use the following command to open a SQLite shell against the database

```bash
docker exec -it db_playground_sqlite sqlite3 /data/northwind.db
```

## SQL Server

Following are the details to connect to the database

```text
Host:     localhost
Port:     1434
Username: sa
Password: Admin@1234
Database: northwind
```

SQL Server requires a strong `sa` password, so it does not use the `admin`/`admin`
credentials shared by the other databases. You can use the following command to run
commands on the database

```bash
docker exec -it db_playground_sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@1234' -d northwind -C
```

## DuckDB

DuckDB is embedded, so there is no host or port. The container is seeded with the Northwind dataset and the database file is also mounted to `./duckdb/data/northwind.db` on the host, so you can open it with any local DuckDB client.

```text
Database: /data/northwind.db (inside the container)
File:     ./duckdb/data/northwind.db (on the host)
Dataset:  northwind
```

You can use the following command to open a DuckDB shell against the database

```bash
docker exec -it db_playground_duckdb duckdb /data/northwind.db
```

## DynamoDB

This uses [DynamoDB Local](https://hub.docker.com/r/amazon/dynamodb-local), so it runs entirely on your machine and accepts any credentials. The Northwind tables are seeded as one DynamoDB table per entity (`categories`, `customers`, `orders`, `order_details`, etc.), plus two feature tables (`feature_showcase`, `orders_by_index`) that exercise secondary indexes, every attribute type, streams and TTL. See [`dynamodb/readme.md`](./dynamodb/readme.md) for the full feature coverage and a catalog of PartiQL test queries.

```text
Host:     localhost
Port:     8000
Region:   us-east-1
AccessKey: local
SecretKey: local
```

You can use the [AWS CLI](https://docs.aws.amazon.com/cli/) against the local endpoint to run commands on the database

```bash
aws dynamodb list-tables --endpoint-url http://localhost:8000

aws dynamodb scan --table-name categories --endpoint-url http://localhost:8000
```

If you do not have the AWS CLI installed locally, the `make dynamodb-cli` target runs it for you inside a throwaway container.

## CockroachDB

CockroachDB runs as a single-node insecure cluster, so it accepts connections as
the `root` user without a password. It is wire-compatible with PostgreSQL, so you
can use any PostgreSQL client to connect.

```text
Host:     localhost
Port:     26257
Username: root
Password: (none, insecure mode)
Database: northwind
```

You can use the following command to run commands on the database

```bash
docker exec -it db_playground_cockroachdb cockroach sql --insecure -d northwind
```

The DB Console (web UI) is available at http://localhost:8081

## Cassandra

Cassandra runs as a single node with authentication disabled, so it accepts
connections without a username or password. The Northwind tables are loaded into
a `northwind` keyspace as standalone wide-column tables, each with a primary key
derived from the original schema (Cassandra does not support joins or foreign
keys).

```text
Host:     localhost
Port:     9042
Username: (none)
Password: (none)
Keyspace: northwind
```

You can use the following command to open a CQL shell on the database

```bash
docker exec -it db_playground_cassandra cqlsh -k northwind
```

## Contributing

* Add support for more databases
* Suggest features
* Discuss ideas in issues
* Spread the word

## License

MIT © [Kamran Ahmed](https://twitter.com/kamranahmedse)
