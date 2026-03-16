#!/bin/bash

OS=$(uname -s)

if [ "$OS" = "Linux" ]; then
    echo "Running on Linux..."
    echo "Game window and output will appear below:"
    echo "-------------------------------------------"
    ./CommunSim-linux.x86_46
elif [ "$OS" = "Darwin" ]; then
    echo "Running on macOS..."
    echo "Game window and output will appear below:"
    echo "-------------------------------------------"
    ./CommunSim.app/Contents/MacOS/CommunSim
elif [[ "$OS" == MINGW* ]] || [[ "$OS" == CYGWIN* ]]; then
    echo "Running on Windows..."
    ./CommunSim.exe
else
    echo "Unknown OS: $OS"
    exit 1
fi

# Keep terminal open after game closes so user can see any final output
echo "-------------------------------------------"
read -p "Game closed. Press Enter to close this window..."
