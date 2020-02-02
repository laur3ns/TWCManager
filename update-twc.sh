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
cd /home/pi/scripts/git/TWCManager

git fetch
git diff --name-only origin/master
confirm || exit 1
git pull || exit 1

rsync -Cavr --progress --delete \
 --exclude=.gitignore \
 --exclude=TWCManagerSettings.txt \
 --exclude=TWCManager.log  \
 /home/pi/scripts/git/TWCManager/ \
 /home/pi/scripts/twc/

cd /home/pi/scripts/twc/
chmod +x TWCManager.py twcmanagerctl update-twc.sh

# Restart
/home/pi/scripts/twc/twcmanagerctl restart