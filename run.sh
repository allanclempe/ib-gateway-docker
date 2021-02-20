#!/bin/bash

set -e
set -o errexit

rm -f /tmp/.X0-lock

Xvfb :0 &
sleep 1

GREEN='\033[0;32m'
NC='\033[0m' # No Color

NUM_PROCS=$IB_INSTANCES

printf "INSTANCES ${GREEN}$IB_INSTANCES${NC}\n"

for ((i=1; i<=IB_INSTANCES; i++))
do
    tws_user="TWSUSERID_$i"
    tws_password="TWSPASSWORD_$i"
    vnc_port="VNC_PORT_$i"
    tws_port="TWS_PORT_$i"

    printf "$i: ${GREEN}${!tws_user}${NC} port ${GREEN}${!tws_port}${NC}\n"

    ./start-ib.sh -u "${!tws_user}" -p "${!tws_password}" -v "${!vnc_port}" -t "${!tws_port}" &
    let 'i>=NUM_PROCS' && wait -n # wait for one process at a time once we've spawned $NUM_PROC workers
done

