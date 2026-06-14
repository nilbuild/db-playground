#!/usr/bin/env bash

set -u

readonly SQLCMD="/opt/mssql-tools/bin/sqlcmd"

echo "[SEED] Seeding Northwind into SQL Server.."

wait () {
  echo "Waiting for SQL Server to start.."
  while true; do
    "$SQLCMD" -S "$DB_HOST" -U sa -P "$SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 1
  done
}

wait

echo "Creating northwind database.."
"$SQLCMD" -S "$DB_HOST" -U sa -P "$SA_PASSWORD" -Q "IF DB_ID('northwind') IS NULL CREATE DATABASE northwind"

echo "Loading dataset.."
"$SQLCMD" -S "$DB_HOST" -U sa -P "$SA_PASSWORD" -d northwind -i dataset/northwind.sql

echo "Done."
