#!/bin/sh

#Install Docker
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Create container image
docker build -t minecraft-server .
# Create volume (for server data persistence)
docker volume create server-data

# Get IP address
ADDRESS="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

# Start container (start server)
docker run --rm -it -p $ADDRESS:25565:25565 -p $ADDRESS:27015:27015 -v server-data:/minecraft minecraft-server sh