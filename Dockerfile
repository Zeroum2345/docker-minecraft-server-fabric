FROM openjdk:21-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y libfreetype6 curl wget

# Install minecraft server dependency (rcon)
RUN curl -L -o rcon-cli.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.6.2/rcon-cli_1.6.2_linux_amd64.tar.gz && \
  tar -xzf rcon-cli.tar.gz && \
  rm rcon-cli.tar.gz && \
  mv rcon-cli /usr/local/bin

# Server Setup (Change version if needed)
RUN wget -O fabric-server-launch.jar https://meta.fabricmc.net/v2/versions/loader/1.21/0.15.11/1.0.1/server/jar

RUN apt-get install unzip

#Change eula to the signed one
COPY ./eula.txt eula.txt

# Copy the entrypoint to the workdir (persist)
COPY ./entrypoint.sh /minecraft/entrypoint.sh

# Copy the server properties to the workdir (persist)
COPY ./server.properties /minecraft/server.properties

# Custom memory alocation
ENV JAVA_MEMORY=4G

# Custom files (download link)
# Blank for default settings
ENV WORLD="" 
ENV MODS="" 

ENTRYPOINT ["sh", "/minecraft/entrypoint.sh"]