## sqlserver-playground

Run the following command to start the playground

```bash
./playground.sh -s sqlserver
```

Following are the details to connect to the database

```text
Host: localhost
Port: 1434
Username: sa
Password: Admin@1234
Database: northwind
```
You can use the following command to run commands on the database
```bash
docker exec -it db_playground_sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@1234' -d northwind -C
```
