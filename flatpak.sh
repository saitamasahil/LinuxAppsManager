#!/usr/bin/env bash

# Define some color variables
GREEN='\033[1m\033[32m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="====================="
    t2="Flatpak App Manager"
    printf "${GREEN}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${GREEN}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${GREEN}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo "1. List All Apps Including Runtimes"
    echo "2. List User Installed Apps"
    echo "3. Update All Apps"
    echo "4. Search and Install App"
    echo "5. Uninstall App"
    echo "6. Downgrade App(Flathub Remote)"
    echo "7. Delete Unused Runtime and Flatpak Cache"
    echo "8. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to list all installed Flatpak apps including runtimes
list_all_apps() {
    echo "Listing All Apps Including Runtimes:"
    sleep 1
    echo "-----------------------"
    flatpak list # Use flatpak command to list apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list user installed flatpak apps
list_user_apps() {
    echo "Listing User Installed Apps:"
    sleep 1
    echo "-----------------------"
    flatpak list --app # Use flatpak command to list apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to update all installed Flatpak apps
update_apps() {
    echo "Updating All Apps..."
    sleep 1
    echo "-----------------------"
    flatpak update -y # Use flatpak command to update all apps with yes option
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search and install a specific Flatpak app
install_app() {
    read -rp "Enter the app name to search: " app_name
    echo "Searching for $app_name..."
    sleep 1
    echo "-----------------------"
    flatpak search "$app_name" # Use flatpak command to search for app name
    sleep 1
    echo "-----------------------"
    read -rp "Enter the exact app name from above shown list to install: " app_install
    flatpak install "$app_install" # Use flatpak command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific Flatpak app
uninstall_app() {
    read -rp "Enter the app name to uninstall: " app_name
    flatpak uninstall "$app_name" # Use flatpak command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to downgrade a specific Flatpak app
downgrade_app() {
    echo "Find the application id in apps list."
    sleep 3
    echo ""
    read -rp "Enter the application id of the app to downgrade: " app_id
    flatpak remote-info --log flathub "$app_id" # Use flatpak command to show the commit history of the app
    sleep 1
    echo "-----------------------"
    read -rp "Enter the commit ID of the version you want: " commit_id
    sudo flatpak update --commit="$commit_id" "$app_id" # Use flatpak command to update the app to a specific commit
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to delete unused runtime and flatpak cache and other unnecessary things
delete_unused() {
    echo "Deleting Unused Runtime and Flatpak Cache..."
    sleep 1
    echo "-----------------------"
    flatpak uninstall --unused # Use flatpak command to uninstall unused runtime
    flatpak repair --user      # Use flatpak command to repair user installation
    flatpak repair --system    # Use flatpak command to repair system installation
    rm -rf ~/.var/app/*/.cache # Use rm command to remove cache files
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
    2) list_user_apps ;;                           # List user apps
    3) update_apps ;;                              # Update all apps
    4) install_app ;;                              # Search and install app
    5) uninstall_app ;;                            # Uninstall app
    6) downgrade_app ;;                            # Downgrade app
    7) delete_unused ;;                            # Delete unused runtime and flatpak cache
    8) main_menu ;;                                # Exit to main menu
    *) echo "Invalid choice. Please try again." ;; # Invalid choice
    esac
done
