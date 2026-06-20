#!/usr/bin/env bash

set -u

readonly CQLSH="cqlsh"
readonly HOST="${DB_HOST:-cassandra}"
readonly PORT="${DB_PORT:-9042}"

echo "[SEED] Seeding Northwind into Cassandra.."

wait_for_db() {
  echo "Waiting for Cassandra to start.."
  while true; do
    "$CQLSH" "$HOST" "$PORT" -e "SELECT now() FROM system.local" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 2
  done
}

wait_for_db

echo "Loading dataset.."
"$CQLSH" "$HOST" "$PORT" -f dataset/northwind.cql

echo "Done."
