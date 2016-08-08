#!/bin/bash
function start() {
    echo "Starting kcptun"
    ./server_linux_amd64 -l :29900 -t 127.0.0.1:8388 -key test -mtu 1400 -sndwnd 2048 -rcvwnd 2048 -mode fast2 > kcptun.log 2>&1 &
    echo "Kcptun started"
}
function stop() {
    echo "Stopping kcptun"
    PID=`ps -ef | grep server_linux_amd64 | grep -v grep | awk '{print $2}'`
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
fi
