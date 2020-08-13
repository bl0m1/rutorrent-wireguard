FROM alpine:3.12

# mediainfo and php-geoip left out
RUN apk add --no-cache rtorrent unzip screen unrar curl php7-fpm php7 php7-json nginx wget ffmpeg supervisor bash wireguard-tools iptables

# rutorrent
RUN mkdir -p /var/www && \
    wget --no-check-certificate https://github.com/Novik/ruTorrent/archive/v3.8.zip && \
    unzip v3.8.zip && \
    mv ruTorrent-3.8 /var/www/rutorrent && \
    rm v3.8.zip
RUN chown -R nginx:nginx /var/www/rutorrent

# niginx
RUN mkdir -p /etc/nginx/sites-enabled && \
    rm /etc/nginx/nginx.conf

# php
RUN mkdir -p /run/php && \
    mkdir -p /var/run/php && \
    rm /etc/php7/php-fpm.conf

# Supervisord
RUN mkdir -p /etc/supervisor.d

#Copy in all files needed
COPY root/ /

# entrypoint
copy entrypoint.sh /entrypoint.sh
RUN chmod 700 /entrypoint.sh

EXPOSE 80

#volumes
VOLUME ["/downloads", "/config"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:80/ || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]
