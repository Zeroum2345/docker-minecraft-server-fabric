#!/bin/sh

# Get IP address
ADDRESS="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

# Start container (start server)
docker run --rm -it -p $ADDRESS:25565:25565 -p $ADDRESS:27015:27015 -v minecraft-server-data:/minecraft minecraft-server sh