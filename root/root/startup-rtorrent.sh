#!/usr/bin/env sh

set -x

# remove old session lock
rm -f /config/session/rtorrent.lock

# run rtorrent
rtorrent -n -o import=/config/.rtorrent.rc -o port_range=$BINDPORT-$BINDPORT