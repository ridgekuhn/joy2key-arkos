#!/bin/bash
# RetroPie joy2key wrapper for ArkOS by ridgek

# Starts joy2key, runs a command,
# then stops joy2key and returns command's exit code
#
# Key mapping arguments should be
# curses capability names or ASCII hex values starting with '0x'
#
# @usage
#		/opt/joy2key/listen.sh myCoolScript.sh kcub1 kcuf1 kcuu1 kcud1 0x0d 0x20 0x1b 0x00 kpp knp
#
# @param $1 {command} A script to run
# @param [$2] {string|hex} key code for d-pad left
# @param [$3] {string|hex} key code for d-pad right
# @param [$4] {string|hex} key code for d-pad up
# @param [$5] {string|hex} key code for d-pad down
# @param [$6] {string|hex} key code for button 1 (A)
# @param [$7] {string|hex} key code for button 2 (B)
# @param [$8] {string|hex} key code for button 3 (X)
# @param [$9] {string|hex} key code for button 4 (Y)
# @param [$10] {string|hex} key code for button 5 (L1)
# @param [$11] {string|hex} key code for button 6 (R1)
if [ "${1}" ] && [ -f "${1}" ]; then
	RUNCOMMAND="${1}"
else
	echo "ERROR: No command specified"
	exit 1
fi

if [ "${2}" ]; then
	KEY_MAPPINGS=(${@:2})
else
	# Keymap to pass to joy2keyStart
	# Default button-to-keyboard mappings:
	# * cursor keys for axis/dpad
	# * carriage return, space and esc for buttons 'a', 'b' and 'x'
	# * page up/page down for buttons 5,6 (shoulder buttons)
	KEY_MAPPINGS=(kcub1 kcuf1 kcuu1 kcud1 0x0d 0x20 0x1b 0x00 kpp knp)
fi

RETROPIE_HELPERS="/opt/joy2key/RetroPie-Setup/scriptmodules/helpers.sh"

###############
# START JOY2KEY
###############
if [ -f "${RETROPIE_HELPERS}" ]; then
	source "${RETROPIE_HELPERS}"

	# Required by joy2keyStart
	scriptdir="/opt/joy2key/RetroPie-Setup"

	joy2keyStart ${KEY_MAPPINGS[@]}
else
	echo "joy2key helpers not found"
	exit 1
fi

#############
# RUN COMMAND
#############
if [ ! -z "${RUNCOMMAND}" ]; then
	"${RUNCOMMAND}"
fi

EXIT_CODE=$?

if [ ${EXIT_CODE} != 0 ]; then
	echo "Error: There was a problem running ${RUNCOMMAND}"
fi

##############
# STOP JOY2KEY
##############
joy2keyStop

exit ${EXIT_CODE}
