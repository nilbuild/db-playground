#!/bin/sh
set -e

KEY_DIR=/keys
KEY="${KEY_DIR}/id_playground"

mkdir -p "${KEY_DIR}"

# Generate the client keypair on first run so the private key lands on the host
# (the /keys dir is bind-mounted to ./sqlite/keys). Apps connect with this key.
if [ ! -f "${KEY}" ]; then
  echo "[sqlite-ssh] Generating SSH keypair at ${KEY}"
  ssh-keygen -t ed25519 -N '' -C 'tablething-app' -f "${KEY}"
fi

# Trust the public key for the playground user
mkdir -p /home/playground/.ssh
cp "${KEY}.pub" /home/playground/.ssh/authorized_keys
chown -R playground:playground /home/playground/.ssh
chmod 700 /home/playground/.ssh
chmod 600 /home/playground/.ssh/authorized_keys

# Let the playground user read (and lock, for RW connections) the database
chown -R playground:playground /data

# Generate host keys and run sshd in the foreground
ssh-keygen -A
echo "[sqlite-ssh] sshd listening on 22 — user 'playground', db at /data/northwind.db"
exec /usr/sbin/sshd -D -e
