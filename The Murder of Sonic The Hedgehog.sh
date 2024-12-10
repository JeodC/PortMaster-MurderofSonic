#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Variables
GAMEDIR=/$directory/ports/tmosonic

# CD and set permissions
cd $GAMEDIR
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
$ESUDO chmod +x -R $GAMEDIR/*

# Exports
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export WINEPREFIX=/storage/.wine64

# Keyboard Entry; edit name here
export TEXTINPUTPRESET="NAME"          # defines preset text to insert
export TEXTINPUTINTERACTIVE="Y"        # enables interactive text input mode
export TEXTINPUTNOAUTOCAPITALS="Y"     # disables automatic capitalization of first letter of words in interactive text input mode
export TEXTINPUTADDEXTRASYMBOLS="Y"    # enables additional symbols for interactive text input

#export WINEPREFIX=/storage/.wine32
#export WINEARCH=win32

# Config Setup
rm -rf ~/.wine64/drive_c/users/root/AppData/LocalLow/Sonic Social/The Murder of Sonic The Hedgehog
ln -s $GAMEDIR/config ~/.wine64/drive_c/users/root/AppData/LocalLow/Sonic Social/The Murder of Sonic The Hedgehog

# Run the game
$GPTOKEYB "The Murder of Sonic The Hedgehog.exe" -c "./tmosonic.gptk" &
box64 wine64 "./data/The Murder of Sonic The Hedgehog.exe"
#box86 wine32 game.exe

# Kill processes
pm_finish