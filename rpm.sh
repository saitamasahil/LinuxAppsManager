#!/usr/bin/env bash

# Define some color variables
Magenta='\033[1m\033[38;5;201m'
PEACH='\e[1;38;2;255;204;153m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="================="
    t2="RPM App Manager"
    printf "${Magenta}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${Magenta}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${Magenta}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo " 1. List All Apps"
    echo " 2. Search Installed App"
    echo " 3. Install RPM Package"
    echo " 4. Uninstall App"
    echo " 5. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to list all installed rpm apps
list_all_apps() {
    echo "Listing All Installed RPM Packages:"
    sleep 1
    echo "-----------------------"
    rpm -qa # List all packages using rpm
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search a specific installed rpm app
search_app() {
    read -rp "Enter the name or keyword of the RPM package to search: " keyword
    echo "Searching for $keyword..."
    sleep 1
    echo "-----------------------"
    rpm -qa | grep "$keyword" # Search for packages using rpm and grep
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to install a rpm file from local path or URL
install_app() {
    read -rp "Enter the local path or URL of the RPM file: " file_path
    if [[ $file_path == http* ]]; then # If file path is a URL
        wget "$file_path"              # Download the file using wget
        file_name=${file_path##*/}     # Extract the file name from the URL
        sudo rpm -i "$file_name"       # Install the file using rpm
        rm "$file_name"                # Remove the downloaded file
    else                               # If file path is a local path
        sudo rpm -i "$file_path"       # Install the file using rpm
    fi
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific rpm app
uninstall_app() {
    read -rp "Enter the name of the RPM package to remove: " package_name
    sudo rpm -e "$package_name" # Remove the package using rpm
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
    2) search_app ;;                                          # Search for specific installed app
    3) install_app ;;                                         # Install app
    4) uninstall_app ;;                                       # Uninstall app
    5) main_menu ;;                                           # Exit to main menu
    *) echo "Invalid choice. Please try again." && sleep 3 ;; # Invalid choice
    esac
done
