#!/bin/bash -x


find /etc/haproxy/services.d/ -mindepth 1 -print0 | \
    xargs -0 -Icfg echo -f cfg | \
    xargs /usr/sbin/haproxy -W -db -p /run/haproxy.pid -f /etc/haproxy/haproxy.cfg
