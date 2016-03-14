#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

export PROJECT_DIR="$(pwd)"

set -x #echo on

# install/main_static.sh
# install/node_asu.sh
# install/node_contactus.sh
install/nginx.sh