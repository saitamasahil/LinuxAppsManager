#!/usr/bin/env bash

# Define some color variables
ORANGE='\033[1m\033[38;5;214m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="================="
    t2="APT App Manager"
    printf "${ORANGE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${ORANGE}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${ORANGE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo "1. List All Apps"
    echo "2. List User Installed Apps"
    echo "3. Update All Apps"
    echo "4. Search and Install App"
    echo "5. Uninstall App"
    echo "6. Delete APT Cache and Unnecessary Data"
    echo "7. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to list all installed apt apps
list_all_apps() {
    echo "Listing All Apps:"
    sleep 1
    echo "-----------------------"
    apt list --installed # Use apt command to list all apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list user installed apt apps
list_user_apps() {
    echo "Listing User Installed Apps:"
    sleep 1
    echo "-----------------------"
    apt list --manual-installed # Use apt command to list user apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to update all installed apt apps
update_apps() {
    echo "Updating All Apps..."
    sleep 1
    echo "-----------------------"
    sudo apt update     # Use sudo and apt command to update the package lists
    sudo apt upgrade -y # Use sudo and apt command to upgrade all apps with yes option
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search & install a specific apt app
install_app() {
    read -rp "Enter the app name to search: " app_name
    echo "Searching for $app_name..."
    sleep 1
    echo "-----------------------"
    apt search "$app_name" # Use apt command to search for app name
    sleep 1
    echo "-----------------------"
    read -rp "Enter the exact app name from above shown list to install: " app_install
    sudo apt install "$app_install" # Use sudo and apt command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific apt app
uninstall_app() {
    read -rp "Enter the app name to uninstall: " app_name
    sudo apt remove "$app_name" # Use sudo and apt command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to delete APT cache and unnecessary data
delete_unused() {
    echo "Deleting APT Cache and Unnecessary Data..."
    sleep 1
    echo "-----------------------"
    sudo apt autoclean                    # Use sudo and apt command to clean up partial packages and cache
    sudo apt autoremove                   # Use sudo and apt command to remove unused packages
    sudo rm -rf /var/cache/apt/archives/* # Use sudo and rm command to remove archived packages
    sleep 1
    read -rp "Press Enter to continue..."
}

# Go back to main menu
main_menu() {
    chmod +x manager.sh
    ./manager.sh
}

# Main loop
while true; do
    display_menu # Display the menu
    read -r choice

    case $choice in                                           # Handle the choice
    1) list_all_apps ;;                                       # List all apps
    2) list_user_apps ;;                                      # List user apps
    3) update_apps ;;                                         # Update all apps
    4) install_app ;;                                         # Install app
    5) uninstall_app ;;                                       # Uninstall app
    6) delete_unused ;;                                       # Delete apt cache and unnecessary data
    7) main_menu ;;                                           # Exit to main menu
    *) echo "Invalid choice. Please try again." && sleep 3 ;; # Invalid choice
    esac
done
