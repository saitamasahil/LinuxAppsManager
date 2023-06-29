#!/usr/bin/env bash

# Define some color variables
PURPLE='\033[1m\033[38;5;140m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Define a function to exit the script
exit_script() {
    clear
    cd ~ # Change directory to home
    # Get the name of the current shell
    shell_name=$(basename "$SHELL")
    # Run the exec command according to the shell
    case $shell_name in
    bash) exec bash ;;
    zsh) exec zsh ;;
    ksh) exec ksh ;;
    csh) exec csh ;;
    tcsh) exec tcsh ;;
    fish) exec fish ;;
    *) echo "Unknown shell: $shell_name" ;;
    esac
}

# Set a trap to call the function when SIGTSTP(ctrl + z) & SIGINT(ctrl + c) is received
trap exit_script SIGTSTP
trap exit_script SIGINT

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
echo "1. APT App Manager"
echo "2. Pacman App Manager"
echo "3. DEB App Manager"
echo "4. DNF App Manager"
echo "5. Snap App Manager"
echo "6. Flatpak App Manager"
echo "7. Update All Packages In Your System"
echo "8. Run Setup"
echo "9. Exit Program"
read -p "Enter your choice: " choice

if [ $choice -eq 1 ]; then
    chmod +x apt.sh && ./apt.sh

elif [ $choice -eq 2 ]; then
    chmod +x pacman.sh && ./pacman.sh

elif [ $choice -eq 3 ]; then
    chmod +x deb.sh && ./deb.sh

elif [ $choice -eq 4 ]; then
    chmod +x dnf.sh && ./dnf.sh

elif [ $choice -eq 5 ]; then
    chmod +x snap.sh && ./snap.sh

elif [ $choice -eq 6 ]; then
    chmod +x flatpak.sh && ./flatpak.sh

elif [ $choice -eq 7 ]; then
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

    # Check if dnf is installed and update it
    if command -v dnf &>/dev/null; then
        echo "dnf is installed, updating packages..."
        sudo dnf upgrade --refresh
        echo ""
    else
        echo "dnf is not installed, skipping..."
        echo ""
    fi

    # Check if snap is installed and update it
    if command -v snap &>/dev/null; then
        echo "snap is installed, updating packages..."
        sudo snap refresh
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

elif [ $choice -eq 8 ]; then
    chmod +x setup.sh && ./setup.sh

elif [ $choice -eq 9 ]; then
    exit_script

else
    echo "Invalid choice. Please try again."
    sleep 3
    chmod +x manager.sh && ./manager.sh
fi
