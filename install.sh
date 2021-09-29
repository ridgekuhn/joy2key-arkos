#!/bin/bash
# RetroPie joy2key wrapper for ArkOS by ridgek

# Install pyudev
if ! python3 -c 'help("modules")' | grep pyudev &>/dev/null; then
	sudo apt update && sudo apt install python3-pyudev -y || (echo "Could not install required dependencies" && exit 1)

# Set lock file for uninstallation
else
	mkdir "/home/ark/.config/joy2key" && touch "/home/ark/.config/joy2key/.pyudev.lock"
fi

# Set script permissions
sudo chmod -v u+x "/opt/joy2key/listen.sh"
sudo chmod -v u+x "/opt/joy2key/RetroPie-Setup/scriptmodules/helpers.sh"
sudo chmod -v u+x "/opt/joy2key/RetroPie-Setup/scriptmodules/supplementary/runcommand/joy2key.py"
sudo chmod -v u+x "/opt/joy2key/uninstall.sh"
