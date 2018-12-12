#!/bin/bash
# get script's real location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [ -f "$SCRIPT_DIR/config.conf" ]; then
  source "$SCRIPT_DIR/config.conf"
fi
if [ "" == "$VPS_ADDRESS" ]; then
  read -rp "INPUT VPS_ADDRESS: " -e VPS_ADDRESS
  echo VPS_ADDRESS="$VPS_ADDRESS" >> "$SCRIPT_DIR/config.conf"
fi
if [ "" == "$LISTEN_PORT" ]; then
  read -rp "INPUT LISTEN_PORT[Default:8388]: " -e LISTEN_PORT
  if [ "" == "$LISTEN_PORT" ]; then
    LISTEN_PORT=8388
  fi
  echo LISTEN_PORT="$LISTEN_PORT" >> "$SCRIPT_DIR/config.conf"
fi

function start() {
    echo "Starting kcptun"
    "$SCRIPT_DIR/client_linux_amd64" -l :$LISTEN_PORT -r "$VPS_ADDRESS:29900" -key test -mtu 1400 -sndwnd 2048 -rcvwnd 2048 -mode fast2 > "$SCRIPT_DIR/kcptun.log" 2>&1 &
    echo "Kcptun started"
}
function stop() {
    echo "Stopping kcptun"
    PID=$(pgrep client_linux_)
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
    echo "    start     start kcptun client"
    echo "    stop      stop kcptun client"
    echo "    restart   restart kcptun client"
fi
