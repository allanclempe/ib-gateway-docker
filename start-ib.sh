#!/bin/bash

while getopts ":u:p:v:t:" opt; do
  case $opt in
    u) p_user="$OPTARG"
    ;;
    p) p_pw="$OPTARG"
    ;;
    v) p_vnc="$OPTARG"
    ;;
    t) p_tws="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

x11vnc -rfbport $p_vnc -display :0 -usepw -forever &
socat TCP-LISTEN:$p_tws,fork TCP:localhost:$p_tws,forever &

# Start this last and directly, so that if the gateway terminates for any reason, the container will stop as well.
# Retry behavior can be implemented by re-running the container.
/opt/ibc/scripts/ibcstart.sh $(ls ~/Jts/ibgateway) --gateway "--mode=$TRADING_MODE" "--user=$p_user" "--pw=$p_pw"
