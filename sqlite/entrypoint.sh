#!/bin/sh
set -e

# Copy the seeded database into the mounted /data directory so the file is
# accessible on the host. A bind mount overlays the image's /data, so the seed
# is staged in /seed at build time and copied in here on first run.
mkdir -p /data
if [ ! -f /data/northwind.db ]; then
  cp /seed/northwind.db /data/northwind.db
fi

exec tail -f /dev/null
