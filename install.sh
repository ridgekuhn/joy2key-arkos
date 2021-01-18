#!/bin/bash
# Install pyudev
if ! python3 -c 'help("modules")' | grep pyudev &> /dev/null; then
	sudo apt update && sudo apt install python3-pyudev -y || (echo "Could not install required dependencies" && exit 1)
fi

sudo chmod -v a+x "/opt/joy2key/listen.sh"
sudo chmod -v a+x "/opt/joy2key/RetroPie-Setup/scriptmodules/helpers.sh"
sudo chmod -v a+x "/opt/joy2key/RetroPie-Setup/scriptmodules/supplementary/runcommand/joy2key.py"
