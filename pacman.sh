#!/usr/bin/env bash

# Define some color variables
PINK='\033[1m\033[38;5;206m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="===================="
    t2="Pacman App Manager"
    printf "${PINK}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${PINK}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${PINK}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo "1. List All Apps"
    echo "2. List User Installed Apps"
    echo "3. Update All Apps"
    echo "4. Search and Install App"
    echo "5. Uninstall App"
    echo "6. Delete Pacman Cache and Unnecessary Data"
    echo "7. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to list all installed pacman apps
list_all_apps() {
    echo "Listing All Apps:"
    sleep 1
    echo "-----------------------"
    pacman -Q # Use pacman command to list all apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list user installed pacman apps
list_user_apps() {
    echo "Listing User Installed Apps:"
    sleep 1
    echo "-----------------------"
    pacman -Qe # Use pacman command to list user apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to update all installed pacman apps
update_apps() {
    echo "Updating All Apps..."
    sleep 1
    echo "-----------------------"
    sudo pacman -Syu --noconfirm # Use sudo and pacman command to update and upgrade all apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search & install a specific pacman app
install_app() {
    read -rp "Enter the app name to search: " app_name
    echo "Searching for $app_name..."
    sleep 1
    echo "-----------------------"
    pacman -Ss "$app_name" # Use pacman command to search for app name
    sleep 1
    echo "-----------------------"
    read -rp "Enter the exact app name from above shown list to install: " app_install
    sudo pacman -S "$app_install" # Use sudo and pacman command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific pacman app
uninstall_app() {
    read -rp "Enter the app name to uninstall: " app_name
    sudo pacman -R "$app_name" # Use sudo and pacman command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to delete Pacman cache and unnecessary data
delete_unused() {
    echo "Deleting Pacman Cache and Unnecessary Data..."
    sleep 1
    echo "-----------------------"
    sudo pacman -Sc                  # Use sudo and pacman command to clean up the cache
    sudo pacman -Rns $(pacman -Qtdq) # Use sudo and pacman command to remove orphan packages
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
    1) list_all_apps ;;                            # List all apps
    2) list_user_apps ;;                           # List user apps
    3) update_apps ;;                              # Update all apps
    4) install_app ;;                              # Install app
    5) uninstall_app ;;                            # Uninstall app
    6) delete_unused ;;                            # Delete pacman cache and unnecessary data
    7) main_menu ;;                                # Exit to main menu
    *) echo "Invalid choice. Please try again." ;; # Invalid choice
    esac
done
