#!/bin/bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

# git update
cd /home/pi/scripts/TWCManager

git fetch
git diff --name-only origin/master
confirm || exit 1
git pull || exit 1

rsync -Cavr --progress --delete \
 --exclude=.gitignore \
 --exclude=TWCManagerSettings.txt \
 --exclude=TWCManager.log  \
 /home/pi/scripts/TWCManager/ \
 /home/pi/scripts/twc/

chmod +x /home/pi/scripts/twc/TWCManager.py
chmod +x /home/pi/scripts/twc/twcmanagerctl

/home/pi/scripts/twc/twcmanagerctl restart