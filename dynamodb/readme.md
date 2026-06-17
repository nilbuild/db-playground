# dynamodb-playground

Run the playground with:

```shell
./playground.sh -s dynamodb   # or: make dynamodb
```

Connection details (DynamoDB Local, accepts any credentials):

```text
Endpoint:  http://localhost:8000
Region:    us-east-1
AccessKey: local
SecretKey: local
```

## What gets seeded

Two datasets are loaded so you can exercise every DynamoDB feature:

1. Northwind — one table per entity (`categories`, `customers`, `products`, `orders`,
   `order_details`, `employees`, `suppliers`, `shippers`, `region`, `territories`,
   `employee_territories`, `us_states`). Realistic volume for scans, filters and pagination
   (`orders` = 830 items, `order_details` = 2155). `customer_demographics` and
   `customer_customer_demo` are intentionally empty for empty-state testing.
2. Feature tables — `feature_showcase` and `orders_by_index`, purpose-built to cover the
   features Northwind cannot reach (secondary indexes, every attribute type, sparse items,
   number precision, reserved words, both billing modes, streams and TTL).

## Feature coverage

| Feature | Where to test it |
|---|---|
| Partition-key-only table | `categories`, `feature_showcase` |
| Partition + sort key table | `order_details`, `orders_by_index` |
| Global secondary index (projection ALL) | `orders_by_index` → `by_status` |
| Global secondary index (projection KEYS_ONLY) | `orders_by_index` → `by_product` |
| Local secondary index | `orders_by_index` → `by_order_date` |
| Sparse index (item missing the index key) | `ORDER#1010` is absent from `by_product` |
| On-demand billing (PAY_PER_REQUEST) | `orders_by_index`, all Northwind tables |
| Provisioned billing | `feature_showcase` |
| Streams (NEW_AND_OLD_IMAGES) | `orders_by_index` |
| TTL | `feature_showcase` (attribute `ttl`) |
| String (S) / Number (N) | everywhere |
| Binary (B) / Binary set (BS) | `feature_showcase` item `all-types` |
| Boolean (BOOL) / Null (NULL) | `feature_showcase` items `all-types`, `booleans-and-nulls` |
| String set (SS) / Number set (NS) | `feature_showcase` item `all-types` |
| Map (M) / List (L), nested | `feature_showcase` items `all-types`, `deeply-nested` |
| Number precision (38 digits, decimals, negatives) | `feature_showcase` item `numbers-precision` |
| Reserved-word attribute names | `feature_showcase` item `reserved-words` |
| Unicode / empty string / empty list / empty map | `feature_showcase` item `unicode-and-empty` |
| Heterogeneous (schemaless) items | `feature_showcase` items `sparse-a`, `sparse-b` |
| Large result set / pagination | `orders`, `order_details` |
| Empty table | `customer_demographics` |

## Test queries (PartiQL)

Table names always need double quotes. Attribute names that are reserved words
(e.g. `region`, `name`, `status`, `size`, `value`) also need double quotes.

Reads and key lookups:

```sql
SELECT * FROM "categories";
SELECT * FROM "customers" WHERE customer_id = 'ALFKI';
SELECT * FROM "order_details" WHERE order_id = 10248;
SELECT * FROM "order_details" WHERE order_id = 10248 AND product_id = 11;
```

Filters and functions:

```sql
SELECT * FROM "customers" WHERE country = 'Germany';
SELECT * FROM "products"  WHERE units_in_stock < 10;
SELECT * FROM "products"  WHERE begins_with(product_name, 'C');
SELECT * FROM "customers" WHERE contains(company_name, 'Market');
SELECT * FROM "orders"    WHERE freight BETWEEN 10 AND 50;
SELECT * FROM "products"  WHERE category_id IN [1, 2];
SELECT * FROM "customers" WHERE attribute_not_exists("region");
```

Secondary indexes:

```sql
SELECT * FROM "orders_by_index"."by_status"     WHERE status = 'SHIPPED';
SELECT * FROM "orders_by_index"."by_product"    WHERE product_id = 'PROD#A';
SELECT * FROM "orders_by_index"."by_order_date" WHERE customer_id = 'ALFKI' AND order_date > '2024-01-01';
```

Rich attribute types and edge cases:

```sql
SELECT * FROM "feature_showcase" WHERE id = 'all-types';
SELECT * FROM "feature_showcase" WHERE id = 'deeply-nested';
SELECT * FROM "feature_showcase" WHERE id = 'numbers-precision';
SELECT * FROM "feature_showcase" WHERE id = 'reserved-words';
SELECT * FROM "feature_showcase";
```

Writes (use a throwaway id):

```sql
INSERT INTO "categories" VALUE {'category_id': 99, 'category_name': 'Test', 'description': 'temp'};
UPDATE "categories" SET description = 'updated' WHERE category_id = 99;
DELETE FROM "categories" WHERE category_id = 99;
```

Pagination and empty state:

```sql
SELECT * FROM "orders";
SELECT * FROM "products" LIMIT 5;
SELECT * FROM "customer_demographics";
```
