FROM alpine:latest

RUN apk add --no-cache sqlite openssh

COPY dataset/northwind.sql /seed/northwind.sql

RUN mkdir -p /data && sqlite3 /data/northwind.db < /seed/northwind.sql

# Login user that apps SSH in as to read /data/northwind.db.
# Give it a password so the account isn't "locked" (sshd rejects locked
# accounts even for key auth), then force key-only auth in sshd.
RUN adduser -D -s /bin/sh playground \
    && echo 'playground:playground' | chpasswd \
    && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

# Generates the SSH keypair (into the mounted /keys dir) and starts sshd
ENTRYPOINT ["/entrypoint.sh"]
