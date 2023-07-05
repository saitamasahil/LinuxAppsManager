#!/usr/bin/env bash

# Define some color variables
PURPLE='\033[1m\033[35m'
PEACH='\e[1;38;2;255;204;153m'
GREEN='\033[1m\033[38;2;0;255;0m'
RED='\033[1m\033[38;5;196m'
AQUA='\e[1;38;2;0;255;255m'
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
echo " 1. APT App Manager"
echo " 2. Pacman App Manager"
echo " 3. DNF App Manager"
echo " 4. DEB App Manager"
echo " 5. RPM App Manager"
echo " 6. Snap App Manager"
echo " 7. Flatpak App Manager"
echo " 8. Update All Packages In Your System"
echo " 9. Run Setup"
echo "10. Update Linux Apps Manager"
echo "11. Exit Program"
echo ""
read -p "Enter your choice: " choice

if [ $choice -eq 1 ]; then
    chmod +x apt.sh && ./apt.sh

elif [ $choice -eq 2 ]; then
    chmod +x pacman.sh && ./pacman.sh

elif [ $choice -eq 3 ]; then
    chmod +x dnf.sh && ./dnf.sh

elif [ $choice -eq 4 ]; then
    chmod +x deb.sh && ./deb.sh

elif [ $choice -eq 5 ]; then
    chmod +x rpm.sh && ./rpm.sh

elif [ $choice -eq 6 ]; then
    chmod +x snap.sh && ./snap.sh

elif [ $choice -eq 7 ]; then
    chmod +x flatpak.sh && ./flatpak.sh

elif [ $choice -eq 8 ]; then
    echo ""
    # Check if apt is available and update it
    if command -v apt &>/dev/null; then
        echo -e "${GREEN}apt is available, updating packages...${NC}"
        sudo apt update && sudo apt upgrade -y
        echo ""
    else
        echo -e "${RED}apt is not available, skipping...${NC}"
        echo ""
    fi

    # Check if pacman is available and update it
    if command -v pacman &>/dev/null; then
        echo -e "${GREEN}pacman is available, updating packages...${NC}"
        sudo pacman -Syu --noconfirm
        echo ""
    else
        echo -e "${RED}pacman is not available, skipping...${NC}"
        echo ""
    fi

    # Check if dnf is available and update it
    if command -v dnf &>/dev/null; then
        echo -e "${GREEN}dnf is available, updating packages...${NC}"
        sudo dnf upgrade --refresh
        echo ""
    else
        echo -e "${RED}dnf is not available, skipping...${NC}"
        echo ""
    fi

    # Check if snap is installed and update it
    if command -v snap &>/dev/null; then
        echo -e "${GREEN}snap is installed, updating packages...${NC}"
        sudo snap refresh
        echo ""
    else
        echo -e "${RED}snap is not installed, skipping...${NC}"
        echo ""
    fi

    # Check if flatpak is installed and update it
    if command -v flatpak &>/dev/null; then
        echo -e "${GREEN}flatpak is installed, updating packages...${NC}"
        flatpak update -y
        echo ""
    else
        echo -e "${RED}flatpak is not installed, skipping...${NC}"
        echo ""
    fi

    echo -e "${AQUA}All done!${NC}"
    read -rp "Press Enter to continue..."
    chmod +x manager.sh && ./manager.sh

elif [ $choice -eq 9 ]; then
    chmod +x setup.sh && ./setup.sh

elif [ $choice -eq 10 ]; then
    echo ""
    echo -e "${GREEN}Downloading updates if available...${NC}"
    sleep 1
    echo ""
    git pull
    if [ $? -ne 0 ]; then
        echo ""
        echo -e "${RED}Checking for update failed! Possible reasons are:${NC}"
        echo "• You have made some changes with LAM."
        echo "• You do not have an internet connection."
        echo "• The remote GitHub repository is not accessible."
    fi
    read -rp "Press Enter to continue..."
    chmod +x manager.sh && ./manager.sh

elif [ $choice -eq 11 ]; then
    exit_script

else
    echo ""
    echo -e "${RED}Invalid choice. Please try again.${NC}"
    sleep 3
    chmod +x manager.sh && ./manager.sh
fi
