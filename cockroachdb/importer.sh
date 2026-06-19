#!/usr/bin/env bash

set -u

readonly COCKROACH="cockroach"
readonly HOST="${DB_HOST:-cockroach}"
readonly PORT="${DB_PORT:-26257}"

echo "[SEED] Seeding Northwind into CockroachDB.."

wait_for_db() {
  echo "Waiting for CockroachDB to start.."
  while true; do
    "$COCKROACH" sql --insecure --host="$HOST" --port="$PORT" -e "SELECT 1" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 1
  done
}

wait_for_db

echo "Creating northwind database.."
"$COCKROACH" sql --insecure --host="$HOST" --port="$PORT" -e "CREATE DATABASE IF NOT EXISTS northwind"

echo "Loading dataset.."
"$COCKROACH" sql --insecure --host="$HOST" --port="$PORT" --database=northwind --set errexit=false -f dataset/northwind.sql

echo "Done."
