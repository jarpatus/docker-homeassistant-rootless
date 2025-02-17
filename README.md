# Home assistant rootless
My take of rootless Home Assistant container. 

Bluetooth does not work as I use bluetooth proxies, USB devices I guess could be mounted to the container with some additional groups.

# Compose file
You may want to use macvlan and some capabilities so do broadcasts can reach the container. 

## Example
```
services:
  hass:
    container_name: hass
    build:
      context: src
      args:
        - UID=8123
        - GID=8123
    restart: always
    cap_add:
      - CAP_NET_BROADCAST
      - CAP_NET_RAW
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./config:/opt/hass/config
    networks:
      macvlan_lan:
        ipv4_address: 10.0.10.2
      macvlan_iot:
        ipv4_address: 10.0.11.2

networks:
  macvlan_lan:
    name: macvlan_lan
    external: true
  macvlan_iot:
    name: macvlan_iot
    external: true
```
