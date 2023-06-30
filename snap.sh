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
    echo "1. Setup Snap"
    echo "2. List All Apps Including Core Components"
    echo "3. List Installed Apps Excluding Core Components"
    echo "4. Update All Apps"
    echo "5. Search & Install App"
    echo "6. Uninstall App"
    echo "7. Downgrade App"
    echo "8. Manage Permissions"
    echo "9. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to install or uninstall snap system in a distro
setup_snap() {
    # Detect the distro name using lsb_release command
    distro=$(lsb_release -si)
    echo "Your distro is $distro."
    sleep 1

    # Check if snap is already installed using command -v
    if command -v snap >/dev/null; then
        echo "Snap is already installed."
        sleep 1
        # Ask the user if they want to uninstall snap
        read -rp "Do you want to uninstall snap? (Y/n): " choice
        case $choice in
        [yY]*) # If yes, then use the appropriate command for the distro
            echo ""
            echo "NOTE: After completing the uninstallation process, don't forget to restart your machine."
            echo ""
            sleep 3
            echo "Uninstalling snap..."
            sleep 1
            case $distro in
            Ubuntu | Debian) # For Ubuntu or Debian based distros, use apt remove
                sudo apt remove --purge snapd -y ;;
            Fedora) # For Fedora based distros, use dnf remove
                sudo dnf remove snapd -y ;;
            Arch | Manjaro) # For Arch or Manjaro based distros, use pacman -R
                sudo pacman -R snapd ;;
            *) # For other distros, show an error message
                echo "Sorry, I don't know how to uninstall snap on your distro." ;;
            esac
            ;;
        [nN]*) # If no, then do nothing and exit the function
            echo "OK, keeping snap." ;;
        *) # If invalid input, show an error message and exit the function
            echo "Invalid input. Please enter y or n." ;;
        esac
    else # If snap is not installed, then use the appropriate command for the distro to install it
        echo "Snap is not installed."
        sleep 1
        echo "Installing snap..."
        sleep 1
        case $distro in
        Ubuntu | Debian) # For Ubuntu or Debian based distros, use apt install
            sudo apt update && sudo apt install snapd -y ;;
        Fedora) # For Fedora based distros, use dnf install
            sudo dnf install snapd -y ;;
        Arch | Manjaro) # For Arch or Manjaro based distros, use pacman -S
            sudo pacman -S snapd ;;
        *) # For other distros, show an error message and exit the function
            echo "Sorry, I don't know how to install snap on your distro." ;;
        esac

        # Add sudo snap install core & store command to activate snap on some distros
        echo "Activating snap..."
        sleep 1
        sudo snap install core
        sudo snap install snap-store
        echo ""
        echo "NOTE: To complete the installation, restart your machine."
        echo ""
        sleep 3

    fi

    sleep 1
    read -rp "Press Enter to continue..."
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
    sudo snap refresh # Use snap command to update all apps
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
    sudo snap install "$app_install" # Use snap command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific Snap app
uninstall_app() {
    read -rp "Enter the app name to uninstall: " app_name
    sudo snap remove --purge "$app_name" # Use snap command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to downgrade a specific Snap app
downgrade_app() {
    read -rp "Enter the app name to downgrade: " app_name
    snap list "$app_name" --all # List the installed versions of the app
    read -rp "Enter the revision number to downgrade to: " rev_num
    sudo snap revert "$app_name" --revision "$rev_num" # Revert to the specified revision
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to manage permissions of Snap apps
manage_permissions() {
    echo "Managing Permissions of Snap Apps..."
    sleep 1
    echo "-----------------------"
    # List all the installed Snap apps
    snap list | grep -v "^core"
    # Ask the user to enter the name of the app they want to manage
    read -rp "Enter the name of the app you want to manage: " app
    echo ""
    sleep 1
    # Check if the app is a valid Snap app
    if snap list | grep -q "^$app"; then
        # List all the interfaces used by the app
        snap connections $app
        # Ask the user to enter the name of the interface they want to manage
        read -rp "Enter the name of the interface you want to manage: " interface
        echo ""
        sleep 1
        # Check if the interface is a valid interface for the app
        if snap connections $app | grep -q "$interface"; then
            # Ask the user to choose an action: connect, disconnect, or cancel
            read -rp "Choose an action: connect, disconnect, or cancel: " action
            echo ""
            sleep 1
            # Perform the action according to the user's choice
            case $action in
            connect)
                # Connect the app to the interface
                snap connect $app:$interface
                echo "$app is connected to $interface"
                ;;
            disconnect)
                # Disconnect the app from the interface
                snap disconnect $app:$interface
                echo "$app is disconnected from $interface"
                ;;
            cancel)
                # Cancel the operation and exit the function
                echo "Operation cancelled"
                sleep 3
                return
                ;;
            *)
                # Invalid action, display an error message and exit the function
                echo "Invalid action, please choose connect, disconnect, or cancel"
                sleep 3
                return
                ;;
            esac
        else
            # Invalid interface, display an error message and exit the function
            echo "$interface is not a valid interface for $app"
            sleep 3
            return
        fi
    else
        # Invalid app, display an error message and exit the function
        echo "$app is not a valid Snap app"
        sleep 3
        return
    fi

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
    1) setup_snap ;;                                          # Install or uninstall snap system in a distro
    2) list_all_apps ;;                                       # List apps
    3) list_user_apps ;;                                      # List installed apps excluding core apps
    4) update_apps ;;                                         # Update all apps
    5) install_app ;;                                         # Search and install app
    6) uninstall_app ;;                                       # Uninstall app
    7) downgrade_app ;;                                       # Downgrade app
    8) manage_permissions ;;                                  # Manage permissions of snap apps
    9) main_menu ;;                                           # Exit to main menu
    *) echo "Invalid choice. Please try again." && sleep 3 ;; # Invalid choice
    esac
done
