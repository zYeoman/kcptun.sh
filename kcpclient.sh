#!/bin/bash
# get script's real location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
function start() {
    echo "Starting kcptun"
    $SCRIPT_DIR/client_linux_amd64 -l :8388 -r $vps:29900 -key test -mtu 1400 -sndwnd 2048 -rcvwnd 2048 -mode fast2 > $SCRIPT_DIR/kcptun.log 2>&1 &
    echo "Kcptun started"
}
function stop() {
    echo "Stopping kcptun"
    PID=`ps -ef | grep client_linux_amd64 | grep -v grep | awk '{print $2}'`
    if [ "" !=  "$PID" ]; then
        echo "killing $PID"
        kill -9 $PID
    fi
    echo "Kcptun stopped"
}
if [ "$1" = "start" ]; then
    start
elif [ "$1" = "stop" ]; then
    stop
elif [ "$1" = "restart" ]; then
    start
    stop
else
    echo "kcptun: "
    echo "    start     start kcptun client"
    echo "    stop      stop kcptun client"
    echo "    restart   restart kcptun client"
fi
