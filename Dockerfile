# Start from Debian
FROM python:3-slim-bookworm

# Build args
ARG UID=8123
ARG GID=8123

# Upgrade
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get upgrade -y

# Install home assistant dependencies
RUN apt-get install -y bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff6 libturbojpeg0-dev tzdata ffmpeg liblapack3 liblapack-dev libatlas-base-dev
RUN apt-get install -y libpcap-dev

# Install some utils needed for debugging etc.
RUN apt-get install -y tcpdump inetutils-telnet nmap net-tools iproute2

# Add user
RUN groupadd -g $GID hass
RUN useradd -d /opt/hass -g $GID -s /sbin/nologin -u $UID hass

# Create config files
RUN mkdir -p /opt/hass/config
RUN chown -R hass:hass /opt/hass

# Drop root
USER hass

# Install home assistant
WORKDIR /opt/hass
RUN python3 -m venv venv
RUN /opt/hass/venv/bin/pip install --upgrade pip
RUN /opt/hass/venv/bin/pip install wheel
RUN /opt/hass/venv/bin/pip install homeassistant

# Run init script
CMD ["/opt/hass/venv/bin/hass", "-c", "/opt/hass/config"]
