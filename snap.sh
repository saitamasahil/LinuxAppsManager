#!/usr/bin/env bash

# Define some color variables
BLUE='\e[1;1;34m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="=================="
    t2="Snap App Manager"
    printf "${BLUE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${BLUE}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${BLUE}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo "1. List All Apps Including Core Components"
    echo "2. List Installed Apps Excluding Core Components"
    echo "3. Update All Apps"
    echo "4. Search and Install App"
    echo "5. Uninstall App"
    echo "6. Downgrade App"
    echo "7. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to list all installed Snap apps
list_all_apps() {
    echo "Listing All Apps Including Core Components:"
    sleep 1
    echo "-----------------------"
    snap list # Use snap command to list apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list installed apps excluding core components
list_user_apps() {
    echo "Listing Installed Apps Excluding Core Component:"
    sleep 1
    echo "-----------------------"
    snap list | grep -v "^core" # Use snap command to list apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to update all installed Snap apps
update_apps() {
    echo "Updating All Apps..."
    sleep 1
    echo "-----------------------"
    snap refresh # Use snap command to update all apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search and install a specific Snap app
install_app() {
    read -rp "Enter the app name to search: " app_name
    echo "Searching for $app_name..."
    sleep 1
    echo "-----------------------"
    snap find "$app_name" # Use snap command to search for app name
    sleep 1
    echo "-----------------------"
    read -rp "Enter the exact app name from above shown list to install: " app_install
    snap install "$app_install" # Use snap command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific Snap app
uninstall_app() {
    read -rp "Enter the app name to uninstall: " app_name
    snap remove --purge "$app_name" # Use snap command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to downgrade a specific Snap app
downgrade_app() {
    read -rp "Enter the app name to downgrade: " app_name
    snap list "$app_name" --all # List the installed versions of the app
    read -rp "Enter the revision number to downgrade to: " rev_num
    snap revert "$app_name" --revision "$rev_num" # Revert to the specified revision
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

    case $choice in                                # Handle the choice
    1) list_all_apps ;;                            # List apps
    2) list_user_apps ;;                           # List installed apps excluding core apps
    3) update_apps ;;                              # Update all apps
    4) install_app ;;                              # Search and install app
    5) uninstall_app ;;                            # Uninstall app
    6) downgrade_app ;;                            # Downgrade app
    7) main_menu ;;                                # Exit to main menu
    *) echo "Invalid choice. Please try again." ;; # Invalid choice
    esac
done
