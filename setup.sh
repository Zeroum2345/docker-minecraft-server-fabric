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
docker volume create minecraft-server-data

./start.sh