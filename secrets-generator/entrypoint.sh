#!/bin/sh

if [ ! -f /opt/secrets/SESSION_SECRET ]; then
  echo "Generating session secret..."
  openssl rand -hex 23 > /opt/secrets/SESSION_SECRET
fi

if [ ! -f /opt/secrets/JWT_SECRET ]; then
  echo "Generating JWT secret..."
  openssl rand -hex 23 > /opt/secrets/JWT_SECRET
fi

if [ ! -f /opt/secrets/STORAGE_ENCRYPTION_KEY ]; then
  echo "Generating storage encryption key..."
  openssl rand -hex 23 > /opt/secrets/STORAGE_ENCRYPTION_KEY
fi
