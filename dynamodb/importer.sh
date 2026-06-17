#!/usr/bin/env bash

set -u

readonly ENDPOINT="http://${DB_HOST:-dynamodb}:${DB_PORT:-8000}"

echo "[SEED] Seeding Northwind into DynamoDB.."

wait () {
  echo "Waiting for DynamoDB to start.."
  while true; do
    aws dynamodb list-tables --endpoint-url "$ENDPOINT" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 1
  done
}

wait

echo "Creating tables.."
for schema in dataset/schema/*.json; do
  table=$(basename "$schema" .json)
  echo "  - $table"
  aws dynamodb create-table \
    --cli-input-json "file://$schema" \
    --endpoint-url "$ENDPOINT" > /dev/null 2>&1
  aws dynamodb wait table-exists \
    --table-name "$table" \
    --endpoint-url "$ENDPOINT" > /dev/null 2>&1
done

echo "Loading data.."
for batch in dataset/items/*/*.json; do
  aws dynamodb batch-write-item \
    --request-items "file://$batch" \
    --endpoint-url "$ENDPOINT" > /dev/null
done

echo "Enabling TTL on feature_showcase.."
aws dynamodb update-time-to-live \
  --table-name feature_showcase \
  --time-to-live-specification "Enabled=true,AttributeName=ttl" \
  --endpoint-url "$ENDPOINT" > /dev/null 2>&1 || echo "  (TTL not supported by this DynamoDB Local version, skipping)"

echo "Done."
