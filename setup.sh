#!/usr/bin/env bash

# Define some color variables
PURPLE='\033[1m\033[38;5;140m'
GREEN='\033[1m\033[32m'
NC='\033[0m' # No Color

# Go back to main menu
main_menu() {
    chmod +x manager.sh
    ./manager.sh
}

# Get the name of the current shell
shell=$(basename "$SHELL")

# Get the current working directory of the script
pwd=$(pwd)

# Show heading in middle
clear
echo ""
COLUMNS=$(tput cols)
t1="=========================="
t2="Linux Apps Manager Setup"
printf "${PURPLE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
printf "${PURPLE}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
printf "${PURPLE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
echo ""

# Ask user what option they want to choose
echo "1. Install Linux Apps Manager In System"
echo "2. Uninstall Linux Apps Manager From System"
echo "3. Go Back To Main Menu"
read -p "Enter your choice: " choice

if [ $choice -eq 1 ]; then
    # This script adds the lam function definition to the appropriate shell configuration file

    # Check if the configuration file exists
    if [ -f ~/."$shell"rc ]; then
        # Check if the lam function is already defined in the file
        if grep -q "lam ()" ~/."$shell"rc; then
            # Delete the existing lam function
            sed -i '/lam ()/,/^}/d' ~/."$shell"rc
        fi

        # Append the function definition to the end of the file
        tail -c1 ~/."$shell"rc | read -r _ || echo "" >>~/."$shell"rc && cat >>~/."$shell"rc <<EOF
lam () {
  # Go to the saved directory
  cd "$pwd"

  # Check if manager.sh exists
  if [ -f manager.sh ]; then
    chmod +x manager.sh && ./manager.sh
  else
    echo "Linux Apps Manager is not available in your system"
  fi
}
EOF
        echo -e "${GREEN}Linux Apps Manager has been successfully installed on your system.${NC}"
        echo -e "${PURPLE}To run Linux Apps Manager, type 'lam' in terminal.${NC}"
        echo -e "${PURPLE}Don't delete the directory where you cloned the repository.${NC}"
        echo ""
        read -n 1 -s -r -p "Press any key to continue..."
        echo
        clear
        cd ~
        $shell

    else
        # Print an error message & make ."$shell"rc file
        echo -e "${PURPLE}."$shell"rc file not found.${NC}"
        echo -e "${GREEN}Fixing this issue.${NC}"
        sleep 3
        touch ~/."$shell"rc
        chmod +x alias.sh && ./alias.sh
    fi

elif [ $choice -eq 2 ]; then
    # Check if the lam function is defined in the .shellrc file
    if grep -q "lam ()" ~/."$shell"rc; then
        # Delete function and directory
        sed -i '/lam ()/,/^}/d' ~/."$shell"rc
        rm -rf "$pwd"
        if [ $? -eq 0 ]; then # check the exit status of rm command
            echo "Uninstalled successfully."
        else
            echo "Failed to uninstall!"
        fi
    else
        echo "Linux Apps Manager isn't available in your system"
    fi

elif [ $choice -eq 3 ]; then
    main_menu
fi
