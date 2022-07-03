FROM debian:buster-slim

ENV USER debian
RUN groupadd -r $USER && useradd -m -r -g $USER $USER

ENV DEBIAN_FRONTEND "noninteractive"
RUN \
  apt-get update && \
  # install VNC & the desktop system
  apt-get install -y xfonts-base=1:1.0.5 lxde=10 tightvncserver=1:1.3.9-9+deb10u1 supervisor=3.3.5-1 && \
  # Install Japanese environment
  #apt-get install -y --no-install-recommends task-japanese=3.53 locales-all=2.28-10+deb10u1 task-japanese-desktop=3.53 fcitx-mozc=2.23.2815.102+dfsg-4 && \
  # Install Utils
  apt-get install -y --no-install-recommends gedit=3.30.2-2 wget=1.20.1-1.1 && \
  apt-get -y clean

RUN \
  apt-get update && \
  apt-get install -y task-japanese=3.53 locales-all=2.28-10+deb10u1 task-japanese-desktop=3.53 && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/*

# Install unrar nonfree
RUN wget http://ftp.de.debian.org/debian/pool/non-free/u/unrar-nonfree/unrar_5.6.6-1_amd64.deb && \
  dpkg -i unrar_5.6.6-1_amd64.deb

# Set VNC password
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
  mkdir /home/$USER/.vnc && \
  echo "vncvnc1" | vncpasswd -f > /home/$USER/.vnc/passwd && \
  chown -R $USER:$USER /home/$USER/.vnc && \
  chmod 600 /home/$USER/.vnc/passwd

COPY etc /etc
WORKDIR /home/$USER
COPY vncserver.sh .
EXPOSE 5900
USER $USER

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

