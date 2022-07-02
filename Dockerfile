FROM debian:buster-slim

ENV USER debian
RUN groupadd -r $USER && useradd -m -r -g $USER $USER

# install VNC & the desktop system
ENV DEBIAN_FRONTEND "noninteractive"
RUN \
  apt-get update && \
  apt-get -y install lxde tightvncserver supervisor

# Install Japanese environment
RUN \
  apt-get install -y task-japanese locales-all task-japanese-desktop

# Set VNC password
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

