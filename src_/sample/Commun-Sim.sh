#!/bin/sh
printf '\033c\033]0;%s\a' CommunSim
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Commun-Sim.x86_64" "$@"
