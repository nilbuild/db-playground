## cassandra-playground

Run the following command to start the playground

```bash
./playground.sh -s cassandra
```

Following are the details to connect to the database

```text
Host:     localhost
Port:     9042
Username: (none)
Password: (none)
Keyspace: northwind
```

Cassandra runs as a single node with authentication disabled, so it does not
require a username or password. You can use the following command to open a CQL
shell against the database

```bash
docker exec -it db_playground_cassandra cqlsh
```

Once connected, switch to the Northwind keyspace and query the data

```sql
USE northwind;
SELECT * FROM customers LIMIT 10;
```

Cassandra is a wide-column store and does not support joins or foreign keys, so
the Northwind tables are loaded as standalone tables, each with a primary key
derived from the original schema.
