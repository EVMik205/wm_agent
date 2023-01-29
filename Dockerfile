# OpenWRT docker image for testing wm_agent
FROM openwrtorg/rootfs
MAINTAINER evmik205@gmail.com
USER root
RUN mkdir -p /var/lock && \
  opkg update && \
  opkg install lua libubus-lua libubox-lua libuci-lua libmosquitto-ssl lua-mosquitto
COPY wm_agent_0.0.1-1_x86_64.ipk /tmp
RUN opkg install /tmp/wm_agent_0.0.1-1_x86_64.ipk
