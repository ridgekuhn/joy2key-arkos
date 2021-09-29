#!/bin/bash
# RetroPie joy2key wrapper for ArkOS by ridgek

# Uninstall pyudev, if applicable
if [ ! -f "/home/ark/.config/joy2key/.pyudev.lock" ]; then
	sudo apt remove python3-pyudev -y
else
	rm -rf "/home/ark/.config/joy2key"
fi

rm -rf "/opt/joy2key"

echo "Uninstallation complete. Thanks for trying joy2key!"
