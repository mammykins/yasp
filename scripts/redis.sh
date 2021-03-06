#!/bin/bash
curl -H "Metadata-Flavor: Google" -L http://metadata.google.internal/computeMetadata/v1/project/attributes/redis > /redis.conf

sudo mkdir -p /var/lib/redis
sudo mount -o discard,defaults /dev/disk/by-id/google-persistent-disk-1 /var/lib/redis
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

sudo docker run -d --name redis --restart=always -v /redis.conf:/usr/local/etc/redis/redis.conf -v /var/lib/redis:/data --net=host redis:3 /usr/local/bin/redis-server /usr/local/etc/redis/redis.conf
sudo docker start redis