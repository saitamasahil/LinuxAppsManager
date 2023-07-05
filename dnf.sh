#!/usr/bin/env bash

# Define some color variables
SKYBLUE='\e[1;38;2;135;206;235m'
PEACH='\e[1;38;2;255;204;153m'
GREEN='\033[1m\033[38;2;0;255;0m'
RED='\033[1m\033[38;5;196m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="================="
    t2="DNF App Manager"
    printf "${SKYBLUE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${SKYBLUE}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${SKYBLUE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo " 1. List All Apps"
    echo " 2. List User Installed Apps"
    echo " 3. Update All Apps"
    echo " 4. Search & Install App"
    echo " 5. Uninstall App"
    echo " 6. Delete DNF Cache & Unnecessary Data"
    echo " 7. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to list all installed dnf apps
list_all_apps() {
    echo ""
    echo -e "${GREEN}Listing All Apps:${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    dnf list installed # Use dnf command to list all apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list user installed dnf apps
list_user_apps() {
    echo ""
    echo -e "${GREEN}Listing User Installed Apps:${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    dnf repoquery --userinstalled # Use dnf command to list user apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to update all installed dnf apps
update_apps() {
    echo ""
    echo -e "${GREEN}Updating All Apps...${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    sudo dnf upgrade --refresh # Use sudo and dnf command to upgrade all apps with refresh option
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search & install a specific dnf app
install_app() {
    echo ""
    read -rp "Enter the app name to search: " app_name
    echo -e "${GREEN}Searching for $app_name...${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    dnf search "$app_name" # Use dnf command to search for app name
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    read -rp "Enter the exact app name from above shown list to install: " app_install
    sudo dnf install "$app_install" # Use sudo and dnf command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific dnf app
uninstall_app() {
    echo ""
    read -rp "Enter the app name to uninstall: " app_name
    sudo dnf remove "$app_name" # Use sudo and dnf command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to delete DNF cache and unnecessary data
delete_unused() {
    echo ""
    echo -e "${GREEN}Deleting DNF Cache & Unnecessary Data...${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    sudo dnf clean all  # Use sudo and dnf command to clean up all cache data
    sudo dnf autoremove # Use sudo and dnf command to remove unused packages
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

    case $choice in                                                                    # Handle the choice
    1) list_all_apps ;;                                                                # List all apps
    2) list_user_apps ;;                                                               # List user apps
    3) update_apps ;;                                                                  # Update all apps
    4) install_app ;;                                                                  # Install app
    5) uninstall_app ;;                                                                # Uninstall app
    6) delete_unused ;;                                                                # Delete apt cache and unnecessary data
    7) main_menu ;;                                                                    # Exit to main menu
    *) echo "" && echo -e "${RED}Invalid choice. Please try again.${NC}" && sleep 3 ;; # Invalid choice
    esac
done
