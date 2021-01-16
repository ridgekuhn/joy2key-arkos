#!/bin/bash
# Joypad input listener for ArkOS using RetroPie joy2key.py loader
# by ridgek
#
# Starts joy2key listener, runs a command, and then stops joy2key
#
# Key mapping arguments should be
# curses capability names or ASCII hex values starting with '0x'
#
# @usage
#		/opt/joy2key/listen.sh myCoolScript.sh (kcub1 kcuf1 kcuu1 kcud1 0x0d 0x20 0x1b)
#
# @param $1 {command} A script to run
# @param [$2] {string|hex} left mapping for left
# @param [$3] {string|hex} right mapping for right
# @param [$4] {string|hex} up mapping for up
# @param [$5] {string|hex} down mapping for down
# @param [$6] {string|hex} but1 mapping for button 1
# @param [$7] {string|hex} but2 mapping for button 2
# @param [$8] {string|hex} but3 mapping for button 3
# @param [$X] {string|hex} butX mapping for button X ...
###########
# PREFLIGHT
###########
if [ ! -z "${1}" ] && [ -f "${1}" ]; then
	RUNCOMMAND="${1}"
else
	echo "Could not run script ${1}"
fi

if [ ! -z "${2}" ]; then
	KEY_MAPPINGS=(${@:2})
else
	# Default keymap to pass to joy2keyStart (left, right, up, down, return, esc)
	KEY_MAPPINGS=(kcub1 kcuf1 kcuu1 kcud1 0x0d 0x1b)
fi

RETROPIE_HELPERS="/opt/joy2key/RetroPie-Setup/scriptmodules/helpers.sh"

#########
# HELPERS
#########
# Cleanup failed environment and exit script
#
# @param 0 {string} - Path to this script
# @param 1 {num} - Exit Code
# @param 2 {string} - Message
errorOut () {
	local exitCode=${1:-1}
	local msg="${2}"

	# Stop listening to joypad input
	joy2keyStop

	# Print message
	if [ ! -z "${msg}" ]; then
		echo "${msg}"
	fi

	exit ${exitCode}
}

###############
# JOY2KEY
###############
if [ -f "${RETROPIE_HELPERS}" ]; then
	source "${RETROPIE_HELPERS}"

	# Required by joy2keyStart
	scriptdir="/opt/joy2key/RetroPie-Setup"

	joy2keyStart ${KEY_MAPPINGS[@]}
else
	echo "joy2key.py not found"
	exit 1
fi

#############
# RUN COMMAND
#############
if [ ! -z "${RUNCOMMAND}" ]; then
	"${RUNCOMMAND}"
fi

if [ $? != 0 ]; then
	errorOut $? "Error: There was a problem running ${RUNCOMMAND}"
fi

##########
# TEARDOWN
##########
joy2keyStop
