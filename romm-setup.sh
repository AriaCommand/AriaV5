#!/bin/bash
# Romm Setup Script for Ugreen NAS
# Run this script on your NAS via SSH

set -e

echo "=========================================="
echo "  Romm Setup Script for Ugreen NAS"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Fix Docker permissions
echo -e "${YELLOW}[Step 1/5] Fixing Docker permissions...${NC}"

# Check if docker group exists
if ! getent group docker > /dev/null 2>&1; then
    echo "Creating docker group..."
    sudo groupadd docker
fi

# Add current user to docker group
CURRENT_USER=$(whoami)
echo "Adding user '$CURRENT_USER' to docker group..."
sudo usermod -aG docker "$CURRENT_USER"

# Start docker service if not running
if ! sudo systemctl is-active --quiet docker 2>/dev/null; then
    echo "Starting Docker service..."
    sudo systemctl start docker
fi

# Enable docker to start on boot
sudo systemctl enable docker 2>/dev/null || true

echo -e "${GREEN}✓ Docker permissions updated${NC}"
echo ""

# Step 2: Create directory structure
echo -e "${YELLOW}[Step 2/5] Creating Romm directory structure...${NC}"

BASE_DIR="/volume1/docker/romm"

# Create all necessary directories
mkdir -p "$BASE_DIR"/{resources,redis,library,assets,config,mysql}

echo "Created directories:"
echo "  - $BASE_DIR/resources  (Game covers, screenshots, etc.)"
echo "  - $BASE_DIR/redis      (Valkey/Redis data)"
echo "  - $BASE_DIR/library    (Your ROM files)"
echo "  - $BASE_DIR/assets     (Romm assets)"
echo "  - $BASE_DIR/config     (Romm configuration)"
echo "  - $BASE_DIR/mysql      (MariaDB data)"

echo -e "${GREEN}✓ Directory structure created${NC}"
echo ""

# Step 3: Create docker-compose.yml
echo -e "${YELLOW}[Step 3/5] Creating docker-compose.yml...${NC}"

cat > "$BASE_DIR/docker-compose.yml" << 'EOF'
services:
  romm:
    image: rommapp/romm:latest
    container_name: romm
    restart: unless-stopped
    environment:
      - DB_HOST=romm-db
      - DB_PORT=3306
      - DB_USER=romm-user
      - DB_PASS=romm-password
      - DB_NAME=romm
      - REDIS_HOST=romm-redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=
      - IGDB_CLIENT_ID=dlqupytxs02iaf7njyxcgblggsq1bd
      - IGDB_CLIENT_SECRET=n0v3yvxl64jb0k8ln313hq94yxxn0c
      - ROMM_AUTH_SECRET_KEY=your-secret-key-change-this
      - ROMM_AUTH_USERNAME=admin
      - ROMM_AUTH_PASSWORD=admin
    volumes:
      - /volume1/docker/romm/resources:/romm/resources
      - /volume1/docker/romm/library:/romm/library
      - /volume1/docker/romm/assets:/romm/assets
      - /volume1/docker/romm/config:/romm/config
    ports:
      - "8998:8080"
    depends_on:
      - romm-db
      - romm-redis
    networks:
      - romm-network

  romm-db:
    image: mariadb:latest
    container_name: romm-db
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=romm-root-password
      - MYSQL_DATABASE=romm
      - MYSQL_USER=romm-user
      - MYSQL_PASSWORD=romm-password
    volumes:
      - /volume1/docker/romm/mysql:/var/lib/mysql
    networks:
      - romm-network

  romm-redis:
    image: valkey/valkey:latest
    container_name: romm-redis
    restart: unless-stopped
    volumes:
      - /volume1/docker/romm/redis:/data
    networks:
      - romm-network

networks:
  romm-network:
    driver: bridge
EOF

echo -e "${GREEN}✓ docker-compose.yml created${NC}"
echo ""

# Step 4: Set proper permissions
echo -e "${YELLOW}[Step 4/5] Setting permissions...${NC}"

# Set ownership for docker volumes (usually 1000:1000 or 999:999 for mysql)
sudo chown -R "$CURRENT_USER:$CURRENT_USER" "$BASE_DIR"
sudo chmod -R 755 "$BASE_DIR"

# MariaDB needs special permissions
sudo mkdir -p "$BASE_DIR/mysql"
sudo chmod 777 "$BASE_DIR/mysql"  # MariaDB will set proper permissions on init

echo -e "${GREEN}✓ Permissions set${NC}"
echo ""

# Step 5: Start containers
echo -e "${YELLOW}[Step 5/5] Starting Romm containers...${NC}"

cd "$BASE_DIR"

# Pull latest images
echo "Pulling Docker images..."
docker compose pull

# Start the stack
echo "Starting containers..."
docker compose up -d

echo ""
echo -e "${GREEN}=========================================="
echo "  Romm Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Romm should be accessible at: http://192.168.0.197:8998"
echo ""
echo "Default credentials:"
echo "  Username: admin"
echo "  Password: admin"
echo ""
echo "IMPORTANT: Change the default password immediately!"
echo ""
echo "Directory structure:"
echo "  Library (ROMs):     /volume1/docker/romm/library"
echo "  Resources:          /volume1/docker/romm/resources"
echo "  Config:             /volume1/docker/romm/config"
echo ""
echo "To check container status:"
echo "  cd /volume1/docker/romm && docker compose ps"
echo ""
echo "To view logs:"
echo "  cd /volume1/docker/romm && docker compose logs -f"
echo ""
echo -e "${YELLOW}NOTE: You may need to log out and back in for Docker permissions to take effect.${NC}"
echo "If docker commands still fail, run: newgrp docker"
