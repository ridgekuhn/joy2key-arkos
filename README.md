# joy2key #
Joypad input listener for ArkOS using [RetroPie](https://github.com/RetroPie/) joy2key.py

---

### joy2keyStart ###
Starts listening for joypad input, and configures joy2key.py mappings.

[joy2keystart]() takes a single argument,
an array of curses capability names or ASCII bytecodes to map to the joypad device.

Order of joypad inputs:
(d-pad left, d-pad right, d-pad up, d-pad down, A, B, X, Y)

`joy2keystart` then calls `joy2key.py`
with the first detected joypad as the input device (`/dev/input/jsX`) and the keypress map.

### joy2keyStop ###
Stops listening for joypad input.

### joy2key.py ###
Maps joypad input to keypresses.

[joy2key.py]() performs autodetection of the joypad passed to it,
and attempts to pair the joypad with a matching
RetroArch-style configuration file stored in 
`/opt/joy2key/udev`. If no matching configuration is found,
the script defaults to `retroarch.cfg`.

### listen.sh ###
A wrapper script for `joy2keyStart`/`joy2keyStop`
which handles setup and teardown for calling external scripts.
It allows failed scripts to exit cleanly
and stop joy2key.py from continuing to listen to input.

`listen.sh` takes two+ arguments;
a script to run, and a keypress map to pass to `joy2key.py`.

### Listening Manually ###

```shell
#!/bin/bash
###########
# PREFLIGHT
###########
RETROPIE_HELPERS="/opt/joy2key/RetroPie-Setup/scriptmodules/helpers.sh"

if [ -f "${RETROPIE_HELPERS}" ]; then
	source "${RETROPIE_HELPERS}"

	# Required by joy2keyStart
	scriptdir="/opt/joy2key/RetroPie-Setup"
	# Keymap to pass to joy2keyStart (left, right, up, down, return, esc)
	KEY_MAPPINGS=(kcub1 kcuf1 kcuu1 kcud1 0x0d 0x1b)

	joy2keyStart ${KEY_MAPPINGS[@]}
else
	echo "joy2key.py not found"
	exit 1
fi

##############
# YOUR PROGRAM
##############

# !!! IMPORTANT !!!
# Do not run code directly here!
# If you do and this script exits unexpectedly,
# the joy2key will not be killed
# and will continue to send keypresses from the joypad.
# This could cause unexpected behavior,
# especially if the analog sticks are "drifting"
"/run/my/script.sh"

##########
# TEARDOWN
##########
joy2keyStop
```
