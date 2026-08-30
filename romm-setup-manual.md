# Romm Setup - Manual Commands

Since you're already SSH'd into your NAS, here are the step-by-step commands to run:

## Step 1: Fix Docker Permissions

```bash
# Add your user to the docker group
sudo usermod -aG docker $(whoami)

# Start docker if not running
sudo systemctl start docker

# Enable docker on boot
sudo systemctl enable docker

# Apply group changes (log out and back in, or use):
newgrp docker

# Test docker access
docker ps
```

## Step 2: Create Directory Structure

```bash
# Create all necessary directories
mkdir -p /volume1/docker/romm/{resources,redis,library,assets,config,mysql}
```

## Step 3: Create docker-compose.yml

```bash
cat > /volume1/docker/romm/docker-compose.yml << 'EOF'
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
```

## Step 4: Set Permissions

```bash
# Set ownership
sudo chown -R $(whoami):$(whoami) /volume1/docker/romm
chmod -R 755 /volume1/docker/romm

# MariaDB needs write access
chmod 777 /volume1/docker/romm/mysql
```

## Step 5: Start Romm

```bash
cd /volume1/docker/romm

# Pull images
docker compose pull

# Start containers
docker compose up -d

# Check status
docker compose ps
```

## Access Romm

- **URL:** http://192.168.0.197:8998
- **Username:** admin
- **Password:** admin

**⚠️ IMPORTANT:** Change the default password immediately after first login!

## Useful Commands

```bash
# View logs
cd /volume1/docker/romm && docker compose logs -f

# Stop Romm
cd /volume1/docker/romm && docker compose down

# Restart Romm
cd /volume1/docker/romm && docker compose restart

# Update Romm
cd /volume1/docker/romm && docker compose pull && docker compose up -d
```

## Adding ROMs

Place your ROM files in `/volume1/docker/romm/library/` organized by platform:

```
/volume1/docker/romm/library/
├── gba/
├── gbc/
├── nes/
├── snes/
├── n64/
├── psx/
└── etc...
```

Romm will automatically scan and match them with IGDB metadata.
