# rutorrent-wireguard

## Usage

```bash
docker run -d --rm --cap-add net_admin --cap-add sys_module --privileged -p 8081:8081 -v wireguard_config:/etc/wireguard -v rutorrent_config:/config -v /mnt/downloads:/downloads  -e WEBUIPORT=8081 -e LAN_NETWORK="192.168.0.0/24" --name wgqb bl0m1/rutorrent-qbittorrent
```

**NOTE: ** Your wireguard config needs to be placed in the volume "wireguard_config" and be called "wg0.conf"

## Envs:
* BINDPORT - specify port (used if you have portforwarding)
* LAN_NETWORK - IPs to bypass wireguard

## volumes:
* /etc/wireguard - used to store wireguard configuration file
* /config - used to store rutorrent configuration
* /downloads - used to stor downloaded files
