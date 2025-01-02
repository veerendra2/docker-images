#!/bin/sh

secrets="SESSION_SECRET JWT_SECRET STORAGE_ENCRYPTION_KEY"

for secret in $secrets; do
  if [ ! -f "/secrets/$secret" ]; then
    echo "Generating $secret..."
    openssl rand -hex 23 > "/secrets/$secret"
  fi
done
