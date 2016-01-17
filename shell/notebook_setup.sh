#!/bin/bash

set -e

# in bash profile
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LD_LIBRARY_PATH=/home/ubuntu/anaconda2/bin/python

IPYTHON=$HOME/anaconda2/bin/ipython
eval $IPYTHON profile create default
CONFIG_PATH=$($IPYTHON locate profile default)/ipython_notebook_config.py

cat > $CONFIG_PATH <<EOF
c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8192
EOF

# -------------------------------------------------------------------------
#   supervisor config for ipython notebook server
# -------------------------------------------------------------------------
cat > /home/ubuntu/supervisord.conf <<EOF
[unix_http_server]
file=/tmp/supervisor.sock                       ; path to your socket file

[supervisord]
logfile=/tmp/supervisord.log                    ; supervisord log file
logfile_maxbytes=50MB                           ; maximum size of logfile before rotation
logfile_backups=10                              ; number of backed up logfiles
loglevel=error                                  ; info, debug, warn, trace
pidfile=/var/run/supervisord.pid                ; pidfile location
nodaemon=false                                  ; run supervisord as a daemon
minfds=1024                                     ; number of startup file descriptors
minprocs=200                                    ; number of process descriptors
user=ubuntu                                     ; default user
childlogdir=/tmp/                               ; where child log files will live

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock         ; use a unix:// URL  for a unix socket

[program:ipython]
directory=/home/ubuntu
environment=HOME="/home/ubuntu",USER="ubuntu",PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
user=ubuntu
command=/home/ubuntu/anaconda2/bin/ipython notebook --config /home/ubuntu/.ipython/profile_default/ipython_notebook_config.py
stderr_logfile = /tmp/ipython-stderr.log
stdout_logfile = /tmp/ipython-stdout.log
EOF
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#   upstart service for supervisor
# -------------------------------------------------------------------------
sudo tee /etc/init/supervisord.conf >/dev/null <<'EOF'
description "supervisord"

start on runlevel [2345]
stop on runlevel [016]
respawn limit 10 5

env LANG=en_US.UTF-8
env LC_CTYPE=en_US.UTF-8

script
    exec /home/ubuntu/anaconda2/bin/supervisord -c /home/ubuntu/supervisord.conf
end script
EOF
init-checkconf /etc/init/supervisord.conf
sudo touch /var/run/supervisord.pid
sudo chmod a+rw /var/run/supervisord.pid
sudo service supervisord start
# -------------------------------------------------------------------------

