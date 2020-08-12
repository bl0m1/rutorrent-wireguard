#!/bin/bash

set -x

# fetch ip for interface wg9, used to bind rtorrent to VPN
IP=$(ip addr show wg0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

export IP=$IP

# run rtorrent
rtorrent -n -o import=/config/.rtorrent.rc -o port_range=$BINDPORT-$BINDPORT -b $IP
