# joy2key #
Joypad input listener for ArkOS using [RetroPie](https://github.com/RetroPie/) joy2key.

This project contains code which is the property of the RetroPie project,
and offers no warranty.
Please see [COPYRIGHT.md](RetroPie-Setup/COPYRIGHT.md) and [LICENSE.md](RetroPie-Setup/LICENSE.md) in [RetroPie-Setup/](RetroPie-Setup)

---

# Usage #

## Using [listen.sh](listen.sh) ##
A wrapper script for [joy2keyStart](RetroPie-Setup/scriptmodules/helpers.sh)/[joy2keyStop](RetroPie-Setup/scriptmodules/helpers.sh)
which handles setup and teardown for calling external scripts.
It allows failed scripts to exit cleanly
by stopping [joy2key](RetroPie-Setup/scriptmodules/supplementary/runcommand/joy2key.py) from continuing to listen to input.

`listen.sh` takes two+ arguments;
a script to run, and a keycode map to pass to `joy2key.py`.

```shell
# Run myCoolScript.sh
/opt/joy2key/listen.sh myCoolScript.sh kcub1 kcuf1 kcuu1 kcud1 0x0d 0x20 0x1b 0x00 kpp knp
```

## Listening Manually ##

```shell
#!/bin/bash
# File containing joy2keyStart() and joy2keyStop()
RETROPIE_HELPERS="/opt/joy2key/RetroPie-Setup/scriptmodules/helpers.sh"

###############
# START JOY2KEY
###############
if [ -f "${RETROPIE_HELPERS}" ]; then
	source "${RETROPIE_HELPERS}"

	# Required by joy2keyStart
	scriptdir="/opt/joy2key/RetroPie-Setup"

	# Keymap to pass to joy2keyStart
	# Default button-to-keyboard mappings:
	# * cursor keys for axis/dpad
	# * carriage return, space and esc for buttons 'a', 'b' and 'x'
	# * page up/page down for buttons 5,6 (shoulder buttons)
	KEY_MAPPINGS=(kcub1 kcuf1 kcuu1 kcud1 0x0d 0x20 0x1b 0x00 kpp knp)

	joy2keyStart ${KEY_MAPPINGS[@]}

else
	echo "joy2key helpers not found"
	exit 1
fi

##############
# YOUR PROGRAM
##############
# Do not run code directly (or call scripts using source or . ) here.
# If you do and the script exits unexpectedly,
# the joy2key process will not be killed
# and will continue to send keypresses from the joypad.
# This could cause unexpected behavior,
# especially if the analog sticks are "drifting"

"/run/my/cmd"

##############
# STOP JOY2KEY
##############
joy2keyStop
```

---

# RetroPie Scripts #

## [joy2keyStart](RetroPie-Setup/scriptmodules/helpers.sh) ##
Starts listening for joypad input, and configures joy2key.py mappings.

[joy2keystart]() takes up to 10 arguments,
as curses capability names or ASCII bytecodes to map to the joypad device.

Order of joypad inputs:
(d-pad left, d-pad right, d-pad up, d-pad down, A, B, X, Y, L1, R1)

`joy2keystart` then calls `joy2key.py` and passes the keypress map.
The input device can be specified by setting `$__joy2key_dev`,
or will default to the first device detected at `/dev/input/jsX`.

## [joy2keyStop](RetroPie-Setup/scriptmodules/helpers.sh) ##
Stops listening for joypad input.

## [joy2key.py](RetroPie-Setup/scriptmodules/supplementary/runcommand/joy2key.py) ##
Maps joypad input to keypresses.

`joy2key.py` attempts to pair the joypad with a matching
RetroArch-style configuration file stored in 
`/home/ark/.config/retroarch/autoconfig/udev/`.
If no matching configuration is found,
the script falls back to the default input configuration in
`/home/ark/.config/retroarch/retroarch.cfg`.
