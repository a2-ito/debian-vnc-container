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
  apt-get install -y --no-install-recommends gedit=3.30.2-2 unrar-free=1:0.0.1+cvs20140707-4 && \
  apt-get -y clean

RUN \
  apt-get update && \
  apt-get install -y task-japanese=3.53 locales-all=2.28-10+deb10u1 task-japanese-desktop=3.53 && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/*

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

