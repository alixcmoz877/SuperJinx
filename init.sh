#!/bin/sh
# JinX X4G init (oneshot): prepare everything before services start.
export PYTHONUNBUFFERED=1
ulimit -n "$(ulimit -Hn 2>/dev/null || echo 65535)" 2>/dev/null || ulimit -n 65535 2>/dev/null || true
mkdir -p /run/jinx /etc/x-ui /var/log/x-ui
i=0
until python3 /opt/jinx/bootstrap.py; do
  i=$((i+1))
  if [ "$i" -ge 3 ]; then echo "[jinx] bootstrap failed 3 times"; exit 1; fi
  echo "[jinx] bootstrap retry $i"; sleep 3
done
nginx -t -c /run/jinx/nginx.conf || { echo "[jinx] nginx config invalid"; exit 1; }
exit 0
