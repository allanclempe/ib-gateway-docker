#!/bin/bash

while getopts ":u:p:t:x:" opt; do
  case $opt in
    u) p_user="$OPTARG"
    ;;
    p) p_pw="$OPTARG"
    ;;
    t) p_tws="$OPTARG"
    ;;
    x) p_api="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

socat TCP-LISTEN:$p_tws,fork TCP:localhost:$p_api,forever &

cp -rf ~/ibc/config.ini ~/ibc/config_$p_api.ini
sed -i "s/OverrideTwsApiPort=/OverrideTwsApiPort=$p_api/" ~/ibc/config_$p_api.ini

# Start this last and directly, so that if the gateway terminates for any reason, the container will stop as well.
# Retry behavior can be implemented by re-running the container.
/opt/ibc/scripts/ibcstart.sh $(ls ~/Jts/ibgateway) --gateway "--mode=$TRADING_MODE" "--user=$p_user" "--pw=$p_pw" "--ibc-ini=/root/ibc/config_$p_api.ini"
