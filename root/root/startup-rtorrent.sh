#!/bin/bash

set -x

# fetch ip for interface wg9, used to bind rtorrent to VPN
IP=$(ip addr show wg0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

export IP=$IP

# run rtorrent
screen -D -m -S \
    rtorrent rtorrent -n -o import=/config/.rtorrent.rc -o port_range=$BINDPORT-$BINDPORT -b $IP

counter=0

until [ -e "/config/session/rtorrent.lock" ] | [ $counter -gt 5 ];
do
    sleep 1s
    ((counter++))
done

rtorrent_pid=$(< /config/session/rtorrent.lock | cut -d '+' -f 2)

wait $rtorrent_pid
exit 1
