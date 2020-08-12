#!/bin/bash

INTERFACE="wg0"

# check for wireguard config, then start wireguard
if [ ! -f /etc/wireguard/"$INTERFACE".conf ]
then
    echo "[error] Could not find /etc/wireguard/"$INTERFACE".conf, exiting ..."
    exit 1
fi

# Create all config directorys if needed 
mkdir -p /config/session /config/watch /config/log/rtorrent /config/.rutorrent/torrents /config/.rutorrent/settings
# fix perms
chown -R nginx:nginx /config/.rutorrent

# verify qbit config
if [ ! -f /config/.rtorrent.rc ]
then
    echo "[info] Config file not found, copying default ..."
    cp /default/.rtorrent.rc /config/.rtorrent.rc
fi

# check if BINDPORT is set
if [ -z "$BINDPORT" ]
then
    echo "[info] BINDPORT not set reverting to default (50000)."
    export BINDPORT=50000
fi

if [ -f /etc/wireguard/"$INTERFACE".conf ]
then
  chmod 600 /etc/wireguard/"$INTERFACE".conf
  wg-quick up "$INTERFACE"
fi

docker_interface="$(route | grep '^default' | awk '{print $8}')"
DEFAULT_GATEWAY="$(route | grep '^default' | awk '{print $2}')"

# split comma separated string into list from LAN_NETWORK env variable
IFS=',' read -ra lan_network_list <<< "${LAN_NETWORK}"

# add lannetworks
for lan_network_item in "${lan_network_list[@]}"; do
    # strip whitespace from start and end of lan_network_item
    lan_network_item=$(echo "${lan_network_item}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')

    echo "[info] Adding ${lan_network_item} as route via ${DEFAULT_GATEWAY} dev ${docker_interface}"
    ip route add "${lan_network_item}" via "${DEFAULT_GATEWAY}" dev "${docker_interface}"
done

# remove old rtorrent session lock
rm -f /config/session/rtorrent.lock

# fetch ip for interface wg9, used to bind rtorrent to VPN
IP=$(ip addr show wg0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# start supervisor
supervisord -c /etc/supervisor.d/supervisord.ini