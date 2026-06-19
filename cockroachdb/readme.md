## cockroachdb-playground

Run the following command to start the playground

```bash
./playground.sh -s cockroachdb
```

Following are the details to connect to the database

```text
Host:     localhost
Port:     26257
Username: root
Password: (none, insecure mode)
Database: northwind
```

CockroachDB runs as a single-node insecure cluster, so it does not require a
password. You can use the following command to run commands on the database

```bash
docker exec -it db_playground_cockroachdb cockroach sql --insecure -d northwind
```

The DB Console (web UI) is available at http://localhost:8081
