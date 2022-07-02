/usr/bin/vncserver :0 -geometry 1280x720 -depth 24 \
  && tail -F $HOME/.vnc/*.log
