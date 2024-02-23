FROM openjdk:17-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y libfreetype6 curl wget

# Install minecraft server dependency (rcon)
RUN curl -L -o rcon-cli.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.6.2/rcon-cli_1.6.2_linux_amd64.tar.gz && \
  tar -xzf rcon-cli.tar.gz && \
  rm rcon-cli.tar.gz && \
  mv rcon-cli /usr/local/bin

# Server Setup (Change version if needed)
RUN wget -c https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.15.7/1.0.0/server/jar -O fabric-server-launch.jar

#Copy the eula to the signed one
COPY ./eula.txt eula.txt

# Copy the entrypoint to the workdir to persist)
COPY ./entrypoint.sh /minecraft/entrypoint.sh

# Copy the server properties to the workdir (to persist)
COPY ./server.properties /server.properties

# Custom memory alocation
ENV JAVA_MEMORY=4G

# Custom files (download link)
# Blank if default settings
ENV WORLD=""
ENV MODS="" 
ENV PLUGINS=""

ENTRYPOINT ["sh", "/minecraft/entrypoint.sh"]