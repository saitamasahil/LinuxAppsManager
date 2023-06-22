#!/usr/bin/env bash

# Define some color variables
PURPLE='\033[1m\033[38;5;140m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Get the name of the current shell
shell=$(basename "$SHELL")

# Show heading in middle
clear
echo ""
COLUMNS=$(tput cols)
t1="===================="
t2="Linux Apps Manager"
printf "${PURPLE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
printf "${PURPLE}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
printf "${PURPLE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
echo ""

# Ask user what option they want to choose
echo -e "${PEACH}Select Your Choice:${NC}"
echo "1. Open APT App Manager"
echo "2. Open Snap App Manager"
echo "3. Open Flatpak App Manager"
echo "4. Run Setup"
read -p "Enter your choice: " choice

if [ $choice -eq 1 ]; then
    chmod +x apt.sh && ./apt.sh
elif [ $choice -eq 2 ]; then
    chmod +x snap.sh && ./snap.sh
elif [ $choice -eq 3 ]; then
    chmod +x flatpak.sh && ./flatpak.sh
elif [ $choice -eq 4 ]; then
    chmod +x setup.sh && ./setup.sh
fi
