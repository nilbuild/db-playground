.PHONY: redis redis-cli mongo mongo-cli postgres postgres-cli mysql mysql-cli mariadb mariadb-cli elasticsearch elasticsearch-cli sqlite sqlite-cli sqlserver sqlserver-cli

redis:
	./playground.sh -s redis
redis-cli:
	@docker exec -it db_playground_redis redis-cli

sqlite:
	./playground.sh -s sqlite
sqlite-cli:
	@docker exec -it db_playground_sqlite sqlite3 /data/northwind.db

mongo:
	./playground.sh -s mongo
mongo-cli:
	@docker exec -it db_playground_mongo mongosh

postgres:
	./playground.sh -s postgres
postgres-cli:
	@docker exec -it db_playground_postgres psql -U admin -d northwind

mysql:
	./playground.sh -s mysql
mysql-cli:
	@docker exec -it db_playground_mysql mysql -u admin -padmin -D northwind

mariadb:
	./playground.sh -s mariadb
mariadb-cli:
	@docker exec -it db_playground_mariadb mariadb -u admin -padmin -D northwind

elasticsearch:
	./playground.sh -s elasticsearch
elasticsearch-cli:
	@echo "Visit http://localhost:9200/_cat/indices?v"

sqlserver:
	./playground.sh -s sqlserver
sqlserver-cli:
	@docker exec -it db_playground_sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@1234' -d northwind -C