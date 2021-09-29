#!/bin/bash
# Modified for ArkOS by ridgek, 09/2021
# For diff, compare to commit:
# @see https://github.com/RetroPie/RetroPie-Setup/commit/bd58256ba2e5ecd79b0447ee18cfb438e7f32286

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md

## @fn joy2keyStart()
## @param left mapping for left
## @param right mapping for right
## @param up mapping for up
## @param down mapping for down
## @param but1 mapping for button 1
## @param but2 mapping for button 2
## @param but3 mapping for button 3
## @param butX mapping for button X ...
## @brief Start joy2key.py process in background to map joystick presses to keyboard
## @details Arguments are curses capability names or hex values starting with '0x'
## see: http://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html
function joy2keyStart() {
    # don't start on SSH sessions
    # (check for bracket in output - ip/name in brackets over a SSH connection)
    [[ "$(who -m)" == *\(* ]] && return

    local params=("$@")
    if [[ "${#params[@]}" -eq 0 ]]; then
				# Default button-to-keyboard mappings:
				# * cursor keys for axis/dpad
				# * carriage return, space and esc for buttons 'a', 'b' and 'x'
				# * page up/page down for buttons 5,6 (shoulder buttons)
        params=(kcub1 kcuf1 kcuu1 kcud1 0x0a 0x20 0x1b 0x00 kpp knp)
    fi

    # Choose the joy2key implementation here, since `runcommand` may not be installed
    local joy2key="joy2key.py"
		# @todo implement sdl version
    #if hasPackage "python3-sdl2"; then
    #    iniConfig " =" '"' "$configdir/all/runcommand.cfg"
    #    iniGet "joy2key_version"
    #    [[ $ini_value != "0" ]] && joy2key="joy2key_sdl.py"
    #fi

    # get the first joystick device (if not already set)
    [[ -c "$__joy2key_dev" ]] || __joy2key_dev="/dev/input/jsX"

    # if no joystick device, or joy2key is already running exit
    [[ -z "$__joy2key_dev" ]] || pgrep -f "$joy2key">/dev/null && return 1

    # if joy2key is installed, run it
    if "$scriptdir/scriptmodules/supplementary/runcommand/$joy2key" "$__joy2key_dev" "${params[@]}" 2>/dev/null; then
        __joy2key_pid=$(pgrep -f "$joy2key")
        return 0
    fi
    return 1
}
## @fn joy2keyStop()
## @brief Stop previously started joy2key.py process.
function joy2keyStop() {
    if [[ -n $__joy2key_pid ]]; then
        kill $__joy2key_pid 2>/dev/null
        __joy2key_pid=""
        sleep 1
    fi
}
