#!/usr/bin/env bash

# Define some color variables
PURPLE='\033[1m\033[38;5;140m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

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
echo "2. Open Pacman App Manager"
echo "3. Open Snap App Manager"
echo "4. Open Flatpak App Manager"
echo "5. Update All Packages In Your System"
echo "6. Run Setup"
read -p "Enter your choice: " choice

if [ $choice -eq 1 ]; then
    chmod +x apt.sh && ./apt.sh

elif [ $choice -eq 2 ]; then
    chmod +x pacman.sh && ./pacman.sh

elif [ $choice -eq 3 ]; then
    chmod +x snap.sh && ./snap.sh

elif [ $choice -eq 4 ]; then
    chmod +x flatpak.sh && ./flatpak.sh

elif [ $choice -eq 5 ]; then
    # Check if apt is installed and update it
    if command -v apt &>/dev/null; then
        echo "apt is installed, updating packages..."
        sudo apt update && sudo apt upgrade -y
        echo ""
    else
        echo "apt is not installed, skipping..."
        echo ""
    fi

    # Check if pacman is installed and update it
    if command -v pacman &>/dev/null; then
        echo "pacman is installed, updating packages..."
        sudo pacman -Syu --noconfirm
        echo ""
    else
        echo "pacman is not installed, skipping..."
        echo ""
    fi

    # Check if snap is installed and update it
    if command -v snap &>/dev/null; then
        echo "snap is installed, updating packages..."
        snap refresh
        echo ""
    else
        echo "snap is not installed, skipping..."
        echo ""
    fi

    # Check if flatpak is installed and update it
    if command -v flatpak &>/dev/null; then
        echo "flatpak is installed, updating packages..."
        flatpak update -y
        echo ""
    else
        echo "flatpak is not installed, skipping..."
        echo ""
    fi

    echo "All done!"
    read -rp "Press Enter to continue..."
    chmod +x manager.sh && ./manager.sh

elif [ $choice -eq 6 ]; then
    chmod +x setup.sh && ./setup.sh

else
    echo "Invalid choice. Please try again."
    sleep 3
    chmod +x manager.sh && ./manager.sh
fi
