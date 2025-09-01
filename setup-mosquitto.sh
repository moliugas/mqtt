#!/bin/bash
set -e

# Variables
APP_NAME="mqtt"
STORAGE_BASE="/var/lib/dokku/data/storage/${APP_NAME}"

echo "Creating Dokku app..."
dokku apps:create $APP_NAME || echo "App $APP_NAME already exists"

echo "Creating persistent storage..."
mkdir -p $STORAGE_BASE/{data,log,config}

dokku storage:mount $APP_NAME $STORAGE_BASE/data:/mosquitto/data
dokku storage:mount $APP_NAME $STORAGE_BASE/log:/mosquitto/log
dokku storage:mount $APP_NAME $STORAGE_BASE/config:/mosquitto/config

echo "Writing minimal Mosquitto config..."
cat > $STORAGE_BASE/config/mosquitto.conf <<EOF
listener 1883 0.0.0.0
bind_address 0.0.0.0
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
EOF

echo "Disabling Dokku HTTP/HTTPS proxy (needed for TCP broker)..."
dokku proxy:disable $APP_NAME || echo "Proxy already disabled"

echo "Pulling and deploying Eclipse Mosquitto image..."
dokku git:from-image $APP_NAME eclipse-mosquitto:2

echo "Restarting app..."
dokku ps:restart $APP_NAME

echo "Mosquitto setup complete!"
echo "Test connection with: nc -zv 127.0.0.1 1883"
echo "Or use: mosquitto_sub -h 127.0.0.1 -t test/topic"
