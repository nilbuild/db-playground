## oracle-playground

Run the following command to start the playground

```bash
./playground.sh -s oracle
```

The Northwind dataset is loaded automatically the first time the container
starts. Initial startup takes a couple of minutes while Oracle sets up the
database; watch the logs for the `DATABASE IS READY TO USE!` message.

Following are the details to connect to the database

```text
Host: localhost
Port: 1521
Service: FREEPDB1
Username: admin
Password: admin
```

You can use the following command to run commands on the database

```bash
docker exec -it db_playground_oracle sqlplus admin/admin@localhost:1521/FREEPDB1
```
