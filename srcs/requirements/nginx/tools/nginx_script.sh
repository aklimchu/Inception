#!/bin/bash

# Check if required environment variables are set
if [ -z "$CERTS_" ] || [ -z "$CERTS_KEY_" ] || [ -z "$DOMAIN_NAME" ]; then
  echo "Error: CERTS_, CERTS_KEY_, or DOMAIN_NAME not set."
  exit 1
fi

# Ensure certificate directory exists
mkdir -p /etc/nginx/certs

# Generate self-signed certificate if not already present
if [ ! -f "$CERTS_" ] || [ ! -f "$CERTS_KEY_" ]; then
  echo "Generating self-signed certificate for $DOMAIN_NAME..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $CERTS_KEY_ \
    -out $CERTS_ \
    -subj "/CN=$DOMAIN_NAME" || {
      echo "Failed to generate certificate"
      exit 1
    }
  chmod 600 $CERTS_KEY_
  chmod 644 $CERTS_
else
  echo "Certificates already exist, skipping generation..."
fi

# Replace the placeholders with environment variables
sed "s|\${CERTS_}|${CERTS_}|g" /etc/nginx/http.d/default.conf > /etc/nginx/http.d/default.conf.tmp
sed "s|\${DOMAIN_NAME}|${DOMAIN_NAME}|g" /etc/nginx/http.d/default.conf.tmp > /etc/nginx/http.d/default.conf
sed "s|\${CERTS_KEY_}|${CERTS_KEY_}|g" /etc/nginx/http.d/default.conf > /etc/nginx/http.d/default.conf.tmp
rm /etc/nginx/http.d/default.conf
mv /etc/nginx/http.d/default.conf.tmp /etc/nginx/http.d/default.conf

# Start Nginx in foreground
echo "Starting Nginx..."
exec nginx -g "daemon off;"