#!/bin/bash
# get script's real location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
if [ -f "$SCRIPT_DIR/config.conf" ]; then
  source "$SCRIPT_DIR/config.conf"
fi
if [ "" == "$VPS_PORT" ]; then
  read -rp "INPUT VPS_PORT[Default:8388]: " -e VPS_PORT
  if [ "" == "$VPS_PORT" ]; then
    VPS_PORT=8388
  fi
  echo VPS_PORT="$VPS_PORT" >> "$SCRIPT_DIR/config.conf"
fi

function start() {
    echo "Starting kcptun"
    "$SCRIPT_DIR/server_linux_amd64" -l :29900 -t 127.0.0.1:$VPS_PORT -key test -mtu 1400 -sndwnd 2048 -rcvwnd 2048 -mode fast2 > "$SCRIPT_DIR/kcptun.log" 2>&1 &
    echo "Kcptun started"
}
function stop() {
    echo "Stopping kcptun"
    PID=$(pgrep server_linux_)
    if [ "" !=  "$PID" ]; then
        echo "killing $PID"
        kill -9 "$PID"
    fi
    echo "Kcptun stopped"
}
if [ "$1" = "start" ]; then
    start
elif [ "$1" = "stop" ]; then
    stop
elif [ "$1" = "restart" ]; then
    stop
    start
else
    echo "kcptun: "
    echo "    start     start kcptun server"
    echo "    stop      stop kcptun server"
    echo "    restart   restart kcptun server"
fi
