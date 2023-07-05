#!/usr/bin/env bash

# Define some color variables
SILVER='\e[1;38;2;192;192;192m'
PEACH='\e[1;38;2;255;204;153m'
GREEN='\033[1m\033[38;2;0;255;0m'
RED='\033[1m\033[38;5;196m'
AQUA='\e[1;38;2;0;255;255m'
NC='\033[0m' # No Color

# Function to display a menu with options
display_menu() {
    # Show heading in middle
    clear
    echo ""
    COLUMNS=$(tput cols)
    t1="=================="
    t2="Snap App Manager"
    printf "${SILVER}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    printf "${SILVER}%*s\n${NC}" $(((${#t2} + $COLUMNS) / 2)) "$t2"
    printf "${SILVER}%*s\n${NC}" $(((${#t1} + $COLUMNS) / 2)) "$t1"
    echo ""
    echo -e "${PEACH}Select Your Choice:${NC}"
    echo " 1. Snap Installer/Uninstaller"
    echo " 2. List All Apps Including Core Components"
    echo " 3. List Installed Apps Excluding Core Components"
    echo " 4. Update All Apps"
    echo " 5. Search & Install App"
    echo " 6. Uninstall App"
    echo " 7. Downgrade App"
    echo " 8. Manage Permissions"
    echo " 9. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to install or uninstall snap system in a distro
setup_snap() {
    echo ""
    # Check if snap is already installed using command -v
    if command -v snap >/dev/null; then
        echo -e "${AQUA}Snap is already installed.${NC}"
        sleep 1
        # Ask the user if they want to uninstall snap
        read -rp "Do you want to uninstall snap including all snap packages/apps? (Y/n): " choice
        case $choice in
        [yY]*)
            # If yes, then use the appropriate command for the package manager
            echo ""
            echo -e "${AQUA}NOTE: After completing the uninstallation process, don't forget to restart your machine.${NC}"
            echo ""
            sleep 3
            echo -e "${RED}Uninstalling snap...${NC}"
            sleep 1
            if command -v apt >/dev/null; then
                sudo apt remove --purge snapd -y
            elif command -v dnf >/dev/null; then
                sudo dnf remove snapd -y
            elif command -v yum >/dev/null; then
                sudo yum remove snapd -y
            elif command -v zypper >/dev/null; then
                sudo zypper remove snapd
            elif command -v pacman >/dev/null; then
                sudo pacman -Rns snapd
            else
                # For other package managers, show an error message
                echo -e "${AQUA}Sorry, I don't know how to uninstall snap on your system.${NC}"
            fi
            ;;
        [nN]*)
            # If no, then do nothing and exit the function
            echo -e "${AQUA}OK, keeping snap.${NC}"
            ;;
        *)
            # If invalid input, show an error message and exit the function
            echo -e "${RED}Invalid input. Please enter y or n.${NC}"
            ;;
        esac
    else
        # If snap is not installed
        echo -e "${AQUA}Snap is not installed.${NC}"
        sleep 1
        # Ask the user if they want to install snap
        read -rp "Do you want to install snap? (Y/n): " choice
        case $choice in
        [yY]*)
            # If yes, then use the appropriate command to install snap
            echo -e "${GREEN}Installing snap...${NC}"
            sleep 1
            echo -e "${AQUA}NOTE: Installing snap on your system may take some time. We appreciate your patience during this process.${NC}"
            sleep 3

            if command -v apt >/dev/null; then
                sudo apt update && sudo apt install snapd -y
            elif command -v dnf >/dev/null; then
                sudo dnf install snapd -y
            elif command -v yum >/dev/null; then
                sudo yum install epel-release -y && sudo yum install snapd -y
            elif command -v zypper >/dev/null; then
                sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.2 snappy && sudo zypper --gpg-auto-import-keys refresh && sudo zypper dup --from snappy && sudo zypper install snapd
                sudo systemctl enable --now snapd
                sudo systemctl enable --now snapd.apparmor
            elif command -v pacman >/dev/null; then
                # Install base-devel and git if they are not already installed
                sudo pacman -S --needed base-devel git

                # Clone the AUR package for snapd
                git clone https://aur.archlinux.org/snapd.git

                # Change to the newly created snapd directory
                cd snapd

                # Build and install the package using makepkg
                makepkg -si

                # Enable and start the snapd.socket systemd unit
                sudo systemctl enable --now snapd.socket

                # Create a symbolic link between /var/lib/snapd/snap and /snap
                sudo ln -s /var/lib/snapd/snap /snap

            else
                # For other package managers, show an error message and exit the function
                echo -e "${AQUA}Sorry, I don't know how to install snap on your system.${NC}"
            fi

            echo -e "${GREEN}Activating snap...${NC}"
            sleep 1
            sudo snap install core
            sudo snap install snap-store
            sudo systemctl enable --now snapd.socket
            sudo ln -s /var/lib/snapd/snap /snap

            echo ""
            echo -e "${AQUA}NOTE: To complete the installation, restart your machine.${NC}"
            echo ""
            sleep 3
            ;;
        [nN]*)
            # If no, then do nothing and exit the function
            echo -e "${AQUA}OK, not installing snap.${NC}"
            ;;
        *)
            # If invalid input, show an error message and exit the function
            echo -e "${RED}Invalid input. Please enter y or n.${NC}"
            ;;
        esac

    fi

    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list all installed Snap apps
list_all_apps() {
    echo ""
    echo -e "${GREEN}Listing All Apps Including Core Components:${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    snap list # Use snap command to list apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to list installed apps excluding core components
list_user_apps() {
    echo ""
    echo -e "${GREEN}Listing Installed Apps Excluding Core Component:${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    snap list | grep -v "^core" # Use snap command to list apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to update all installed Snap apps
update_apps() {
    echo ""
    echo -e "${GREEN}Updating All Apps...${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    sudo snap refresh # Use snap command to update all apps
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to search and install a specific Snap app
install_app() {
    echo ""
    read -rp "Enter the app name to search: " app_name
    echo -e "${GREEN}Searching for $app_name...${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    snap find "$app_name" # Use snap command to search for app name
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
    read -rp "Enter the exact app name from above shown list to install: " app_install
    sudo snap install "$app_install" # Use snap command to install app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to uninstall a specific Snap app
uninstall_app() {
    echo ""
    read -rp "Enter the app name to uninstall: " app_name
    sudo snap remove --purge "$app_name" # Use snap command to uninstall app
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to downgrade a specific Snap app
downgrade_app() {
    echo ""
    read -rp "Enter the app name to downgrade: " app_name
    snap list "$app_name" --all # List the installed versions of the app
    read -rp "Enter the revision number to downgrade to: " rev_num
    sudo snap revert "$app_name" --revision "$rev_num" # Revert to the specified revision
    sleep 1
    read -rp "Press Enter to continue..."
}

# Function to manage permissions of Snap apps
manage_permissions() {
    echo ""
    echo -e "${GREEN}Managing Permissions of Snap Apps...${NC}"
    sleep 1
    echo -e "${GREEN}-----------------------${NC}"
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
                echo -e "${AQUA}$app is connected to $interface${NC}"
                ;;
            disconnect)
                # Disconnect the app from the interface
                snap disconnect $app:$interface
                echo -e "${AQUA}$app is disconnected from $interface${NC}"
                ;;
            cancel)
                # Cancel the operation and exit the function
                echo -e "${AQUA}Operation cancelled${NC}"
                sleep 3
                return
                ;;
            *)
                # Invalid action, display an error message and exit the function
                echo -e "${RED}Invalid action, please choose connect, disconnect, or cancel.${NC}"
                sleep 3
                return
                ;;
            esac
        else
            # Invalid interface, display an error message and exit the function
            echo -e "${RED}$interface is not a valid interface for $app${NC}"
            sleep 3
            return
        fi
    else
        # Invalid app, display an error message and exit the function
        echo -e "${RED}$app is not a valid Snap app${NC}"
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

    case $choice in                                                                    # Handle the choice
    1) setup_snap ;;                                                                   # Install or uninstall snap system in a distro
    2) list_all_apps ;;                                                                # List apps
    3) list_user_apps ;;                                                               # List installed apps excluding core apps
    4) update_apps ;;                                                                  # Update all apps
    5) install_app ;;                                                                  # Search and install app
    6) uninstall_app ;;                                                                # Uninstall app
    7) downgrade_app ;;                                                                # Downgrade app
    8) manage_permissions ;;                                                           # Manage permissions of snap apps
    9) main_menu ;;                                                                    # Exit to main menu
    *) echo "" && echo -e "${RED}Invalid choice. Please try again.${NC}" && sleep 3 ;; # Invalid choice
    esac
done
