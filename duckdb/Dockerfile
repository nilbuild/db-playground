FROM alpine:latest

ARG DUCKDB_VERSION=v1.5.3

RUN apk add --no-cache curl unzip libstdc++ libgcc

RUN ARCH="$(uname -m)"; \
    case "$ARCH" in \
      x86_64)  DUCKDB_ARCH="amd64" ;; \
      aarch64) DUCKDB_ARCH="arm64" ;; \
      *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/duckdb.zip \
      "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-${DUCKDB_ARCH}-musl.zip" && \
    unzip /tmp/duckdb.zip -d /usr/local/bin && \
    rm /tmp/duckdb.zip && \
    chmod +x /usr/local/bin/duckdb

COPY dataset/northwind.sql /seed/northwind.sql

RUN duckdb /seed/northwind.db < /seed/northwind.sql

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
