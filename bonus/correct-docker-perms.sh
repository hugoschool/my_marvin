#!/usr/bin/env bash

if [[ $1 == "--reset" ]]; then
    echo "Reset docker socket"
    sudo chmod 777 /var/run/docker.sock
    exit 0
fi

echo "Correctly set docker socket"
sudo chmod 757 /var/run/docker.sock
