FROM alpine:latest

RUN apk add --no-cache sqlite

COPY dataset/northwind.sql /seed/northwind.sql

RUN mkdir -p /data && sqlite3 /data/northwind.db < /seed/northwind.sql

# Keep the container running so you can `docker exec` into it
CMD ["tail", "-f", "/dev/null"]
