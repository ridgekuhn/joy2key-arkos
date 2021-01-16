#!/bin/bash
# This file is part of The RetroPie Project
# Modified for ArkOS by ridgek, Dec 2020
#
# The RetroPie Project is the legal property of its developers, see
# https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/COPYRIGHT.md
#
# The RetroPie Project and this script are released under a GPLv3 license, see
# https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md

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
        params=(kcub1 kcuf1 kcuu1 kcud1 0x0a 0x20 0x1b)
    fi
    # get the first joystick device (if not already set)
    [[ -c "$__joy2key_dev" ]] || __joy2key_dev="/dev/input/jsX"
    # if no joystick device, or joy2key is already running exit
    [[ -z "$__joy2key_dev" ]] || pgrep -f joy2key.py >/dev/null && return 1
    # if joy2key.py is installed run it with cursor keys for axis/dpad, and enter + space for buttons 0 and 1
    if "$scriptdir/scriptmodules/supplementary/runcommand/joy2key.py" "$__joy2key_dev" "${params[@]}" 2>/dev/null; then
        __joy2key_pid=$(pgrep -f joy2key.py)
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
