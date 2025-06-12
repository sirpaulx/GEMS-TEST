#!/bin/bash
set -e

# Configuration
IMAGE="ghcr.io/sirpaulx/rad:latest"
DOMAIN="radio.pauldevops.duckdns.org"
NETWORK="traefik_net"
CONTAINER_NAME="radio-app"

# Exit if token not set
if [ -z "$GHCR_TOKEN" ]; then
  echo "❌ Error: GHCR_TOKEN environment variable not set!"
  exit 1
fi

# Login to GitHub Container Registry
echo "🔑 Logging in to GitHub Container Registry..."
echo "$GHCR_TOKEN" | docker login ghcr.io -u sirpaulx --password-stdin

# Pull the latest image
echo "⬇️ Pulling latest Docker image..."
docker pull $IMAGE

# Stop and remove existing container
if docker ps -a | grep -q $CONTAINER_NAME; then
    echo "♻️ Removing existing container..."
    docker stop $CONTAINER_NAME >/dev/null 2>&1 || true
    docker rm $CONTAINER_NAME >/dev/null 2>&1 || true
fi

# Deploy the container
echo "🚀 Deploying radio application..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  --network $NETWORK \
  -l "traefik.enable=true" \
  -l "traefik.http.routers.radio.rule=Host(\`$DOMAIN\`)" \
  -l "traefik.http.routers.radio.entrypoints=websecure" \
  -l "traefik.http.routers.radio.tls.certresolver=myresolver" \
  -l "traefik.http.services.radio.loadbalancer.server.port=80" \
  $IMAGE

# Cleanup
echo "🧹 Cleaning up Docker credentials..."
docker logout ghcr.io >/dev/null 2>&1
unset GHCR_TOKEN

echo "✅ Radio app deployed at https://$DOMAIN"
echo "⏳ Allow 1-2 minutes for SSL certificate provisioning"
