#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

set -x #echo on

DIRECTORY="node_asu"

if [ -d "$DIRECTORY" ]; then
    cd $DIRECTORY
    sudo -H -u $SUDO_USER -s bash -c "git pull --rebase -v"
else
    sudo -H -u $SUDO_USER -s bash -c "git clone git@git.spacegazebo.com:SharpAuctionEngine/AuctioneerSignUp.git $DIRECTORY --branch=master"
    cd $DIRECTORY
fi

sudo -H -u $SUDO_USER -s bash -c "npm install" &

wait

echo "$DIRECTORY finished"
# tmux kill-pane

cd $PROJECT_DIR

exit
