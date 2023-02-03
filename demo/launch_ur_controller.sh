#!/bin/bash
set -e

echo "turning on AUX power"
rosservice call /panther/hardware/aux_power_enable "data: true"

echo "Waiting for UR robot ..."
while ! ping -c 1 -n -w 1 10.15.20.4 &> /dev/null
do
    echo "Waiting for UR robot ..."
    sleep 1
done
echo "Controller is available"

echo "Waiting for controller to boot. It may take a while"
# TODO: add checking if controller has launched, for now just sleep
sleep 90
echo "Controller launched"