FROM alpine:latest

RUN apk add --no-cache sqlite

COPY dataset/northwind.sql /seed/northwind.sql

RUN sqlite3 /seed/northwind.db < /seed/northwind.sql

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
