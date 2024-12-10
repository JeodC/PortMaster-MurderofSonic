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

# Display loading splash
[ "$CFW_NAME" == "muOS" ] && $ESUDO $GAMEDIR/splash "splash.png" 1
$ESUDO $GAMEDIR/splash "splash.png" 30000 & 

# Exports
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export WINEPREFIX=~/.wine64
export WINEDEBUG=-all

# Keyboard Entry; edit name here
export TEXTINPUTPRESET="NAME"          # defines preset text to insert
export TEXTINPUTINTERACTIVE="Y"        # enables interactive text input mode
export TEXTINPUTNOAUTOCAPITALS="Y"     # disables automatic capitalization of first letter of words in interactive text input mode
export TEXTINPUTADDEXTRASYMBOLS="Y"    # enables additional symbols for interactive text input

# Config Setup
mkdir -p $GAMEDIR/config
bind_directories "$WINEPREFIX/drive_c/users/root/AppData/LocalLow/Sonic Social/The Murder of Sonic The Hedgehog" "$GAMEDIR/config"

# Run the game
$GPTOKEYB "The Murder of Sonic The Hedgehog.exe" -c "./tmosonic.gptk" &
box64 wine64 "./data/The Murder of Sonic The Hedgehog.exe"

# Kill processes
wineserver -k
pm_finish