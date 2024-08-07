#!/bin/sh -e

# Add the custom files (world, mods, plugins)
# Mods =======================
if [ "${MODS}" != "" ]; then 
  # if [ ! "$(ls -A /minecraft/mods)" ]; then 
    echo "Installing custom mods ${MODS}"
    
    # Create mods folder
    if [ ! -d "/minecraft/mods" ]; then
      mkdir /minecraft/mods
    fi

    # Download and extract to the mods folder
    cd /tmp && \
      wget -O mods.zip ${MODS} && \
      unzip mods.zip -d /minecraft/mods && \
      mv /minecraft/mods/*/*.jar /minecraft/mods && \
      rm mods.zip
  # fi
fi

if [ "${WORLD}" != "" ]; then 
  # if [ ! "$(ls -A /minecraft/mods)" ]; then 
    echo "Installing custom world ${WORLD}"
    
    # Create world folder
    if [ ! -d "/minecraft/world" ]; then
      mkdir /minecraft/world
    fi

    # Download and extract to the world folder
    cd /tmp && \
      wget -O world.zip ${WORLD} && \
      unzip world.zip -d /minecraft/world && \
      mv /minecraft/world/*/* /minecraft/world && \
      rm world.zip
  # fi
fi

# Set important files, so they can persist
if [ ! -d "/minecraft/config" ]; then
  mkdir /minecraft/config
fi

# If the file don't exist, create it
if [ ! -f "/minecraft/config/banned-ips.json" ]; then
  echo "[]" >> /minecraft/config/banned-ips.json
  ln -s /minecraft/config/banned-ips.json /minecraft/banned-ips.json
fi

if [ ! -f "/minecraft/config/banned-players.json" ]; then
  echo "[]" >> /minecraft/config/banned-players.json
  ln -s /minecraft/config/banned-players.json /minecraft/banned-players.json
fi

if [ ! -f "/minecraft/config/usercache.json" ]; then
  echo "[]" >> /minecraft/config/usercache.json
  ln -s /minecraft/config/usercache.json /minecraft/usercache.json
fi

if [ ! -f "/minecraft/config/whitelist.json" ]; then
  echo "[]" >> /minecraft/config/whitelist.json
  ln -s /minecraft/config/whitelist.json /minecraft/whitelist.json
fi

if [ ! -f "/minecraft/config/ops.json" ]; then
  echo "[]" >> /minecraft/config/ops.json
  ln -s /minecraft/config/whitelist.json /minecraft/ops.json
fi

if [ ! -f "/minecraft/config/bukkit.yml" ]; then
  cat <<EOF > /minecraft/config/bukkit.yml
    # This is the main configuration file for Bukkit.
    # As you can see, there's actually not that much to configure without any plugins.
    # For a reference for any variable inside this file, check out the Bukkit Wiki at
    # https://www.spigotmc.org/go/bukkit-yml
    #
    # If you need help on this file, feel free to join us on irc or leave a message
    # on the forums asking for advice.
    #
    # IRC: #spigot @ irc.spi.gt
    #    (If this means nothing to you, just go to https://www.spigotmc.org/go/irc )
    # Forums: https://www.spigotmc.org/
    # Bug tracker: https://www.spigotmc.org/go/bugs
    
    
    settings:
      allow-end: true
      warn-on-overload: true
      permissions-file: permissions.yml
      update-folder: update
      plugin-profiling: false
      connection-throttle: 4000
      query-plugins: true
      deprecated-verbose: default
      shutdown-message: Server closed
      minimum-api: none
    spawn-limits:
      monsters: 70
      animals: 10
      water-animals: 5
      water-ambient: 20
      ambient: 15
    chunk-gc:
      period-in-ticks: 600
    ticks-per:
      animal-spawns: 400
      monster-spawns: 1
      water-spawns: 1
      water-ambient-spawns: 1
      ambient-spawns: 1
      autosave: 6000
    aliases: now-in-commands.yml
EOF
ln -s /minecraft/config/bukkit.yml /minecraft/bukkit.yml
fi

# Start the server
cd /minecraft
java -Xmx${JAVA_MEMORY} -Xms${JAVA_MEMORY} -Dfml.queryResult=confirm -jar fabric-server-launch.jar --nogui