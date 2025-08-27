#!/bin/ash
# Usage: script.sh <identifier> <certificate_path> <private_key_path>
IDENTIFIER="$1"
CERT_PATH="$2"
KEY_PATH="$3"

BASE_PATH="$XDG_DATA_HOME/caddy/"

# Check if all parameters are provided
if [ -z "$IDENTIFIER" ] || [ -z "$CERT_PATH" ] || [ -z "$KEY_PATH" ]; then
  echo "Missing parameters. Usage: $0 <identifier> <certificate_path> <private_key_path>"
  exit 1
fi

# Check if certificate and private key files exist
if [ ! -f "$BASE_PATH$CERT_PATH" ] || [ ! -f "$BASE_PATH$KEY_PATH" ]; then
  echo "Certificate file $BASE_PATH$CERT_PATH or private key file $BASE_PATH$KEY_PATH not found"
  exit 1
fi

# Create destination directory
DEST_DIR="/opt/share/certs/$IDENTIFIER"
mkdir -p "$DEST_DIR"
chmod 700 "$DEST_DIR"

# Copy files
cp -f "$BASE_PATH$CERT_PATH" "$DEST_DIR/$IDENTIFIER.crt"
cp -f "$BASE_PATH$KEY_PATH" "$DEST_DIR/$IDENTIFIER.key"
echo "Certificate and key files copied to $DEST_DIR"

# Check if IDENTIFIER is in ACTION_DOMAINS
# Split ACTION_DOMAINS by comma
IFS=','
for domain in $ACTION_DOMAINS; do
  if [ "$domain" = "$IDENTIFIER" ]; then
    echo "Identifier $IDENTIFIER matches $domain in ACTION_DOMAINS"
    #echo "Reloading PostgreSQL config..."
    #chmod g+rx $DEST_DIR
    #chmod g+r $DEST_DIR/$IDENTIFIER.*
    #chgrp -R postgres $DEST_DIR
    #curl -H "Content-Type: application/json" -d "{\"username\": \"caddy@$HOST_NAME\", \"content\": \"Reloading PostgreSQL config...\"}" $DISCORD_WEBHOOK
    #psql postgresql://postgres:${POSTGRES_PASSWORD}@postgresql -c "SELECT pg_reload_conf();"
    #echo "Reloading Stalwart certificates..."
    #curl -H "Content-Type: application/json" -d "{\"username\": \"caddy@$HOST_NAME\", \"content\": \"Reloading Stalwart certificates...\"}" $DISCORD_WEBHOOK
    #stalwart-cli -u http://stalwart:8080 -c $STW_CREDENTIALS server reload-certificates
    break
  fi
done
