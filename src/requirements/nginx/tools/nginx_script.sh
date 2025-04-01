#!/bin/bash

# Ensure certificate directory exists
mkdir -p /etc/nginx/certs

# Generate self-signed certificate if not already present
if [ ! -f "/etc/nginx/certs/aklimchu.42.fr.crt" ] || [ ! -f "/etc/nginx/certs/aklimchu.42.fr.key" ]; then
  echo "Generating self-signed certificate for aklimchu.42.fr..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/aklimchu.42.fr.key \
    -out /etc/nginx/certs/aklimchu.42.fr.crt \
    -subj "/CN=aklimchu.42.fr" || {
      echo "Failed to generate certificate"
      exit 1
    }
  chmod 600 /etc/nginx/certs/aklimchu.42.fr.key
  chmod 644 /etc/nginx/certs/aklimchu.42.fr.crt
else
  echo "Certificates already exist, skipping generation..."
fi

# Start Nginx in foreground
echo "Starting Nginx..."
exec nginx -g "daemon off;"