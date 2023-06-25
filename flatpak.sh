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
    echo "1. Setup Flatpak"
    echo "2. List All Apps Including Runtimes"
    echo "3. List User Installed Apps"
    echo "4. Update All Apps"
    echo "5. Search and Install App"
    echo "6. Uninstall App"
    echo "7. Downgrade App(Flathub Remote)"
    echo "8. Delete Unused Runtime and Flatpak Cache"
    echo "9. Manage Permissions"
    echo "10. Go Back To Main Menu"
    echo ""
    echo -n "Enter your choice: "
}

# Function to install or uninstall flatpak system in a distro
setup_flatpak() {
    # Detect the distro name using lsb_release command
    distro=$(lsb_release -si)
    echo "Your distro is $distro."
    sleep 1

    # Check if flatpak is already installed using command -v
    if command -v flatpak >/dev/null; then
        echo "Flatpak is already installed."
        sleep 1
        # Ask the user if they want to uninstall flatpak
        read -rp "Do you want to uninstall flatpak? (Y/n): " choice
        case $choice in
        [yY]*) # If yes, then use the appropriate command for the distro
            echo "Uninstalling flatpak..."
            sleep 1
            case $distro in
            Ubuntu | Debian) # For Ubuntu or Debian based distros, use apt remove
                sudo apt remove --purge flatpak -y ;;
            Fedora) # For Fedora based distros, use dnf remove
                sudo dnf remove flatpak -y ;;
            Arch | Manjaro) # For Arch or Manjaro based distros, use pacman -R
                sudo pacman -R flatpak ;;
            *) # For other distros, show an error message
                echo "Sorry, I don't know how to uninstall flatpak on your distro." ;;
            esac
            ;;
        [nN]*) # If no, then do nothing and exit the function
            echo "OK, keeping flatpak." ;;
        *) # If invalid input, show an error message and exit the function
            echo "Invalid input. Please enter y or n." ;;
        esac
    else # If flatpak is not installed, then use the appropriate command for the distro to install it
        echo "Flatpak is not installed."
        sleep 1
        echo "Installing flatpak..."
        sleep 1
        case $distro in
        Ubuntu | Debian) # For Ubuntu or Debian based distros, use apt install
            sudo apt update && sudo apt install flatpak -y ;;
        Fedora) # For Fedora based distros, use dnf install
            sudo dnf install flatpak -y ;;
        Arch | Manjaro) # For Arch or Manjaro based distros, use pacman -S
            sudo pacman -S flatpak ;;
        *) # For other distros, show an error message and exit the function
            echo "Sorry, I don't know how to install flatpak on your distro." ;;
        esac

        # Add flathub repo
        echo "Adding flathub repo..."
        sleep 1
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    fi

    sleep 1
    read -rp "Press Enter to continue..."
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

# Function to manage permissions for Flatpak apps using Flatseal
manage_permissions() {
    echo "Managing Permissions for Flatpak Apps..."
    sleep 1
    echo "-----------------------"
    # Check if Flatseal is installed
    if flatpak list --app | grep -q "Flatseal"; then
        :
    else
        echo "Flatseal is not installed. Installing it now..."
        flatpak install com.github.tchx84.Flatseal -y # Use flatpak command to install Flatseal with yes option
    fi
    # Launch Flatseal
    echo "Launching Flatseal..."
    flatpak run com.github.tchx84.Flatseal & # Use flatpak command to run Flatseal in the background
    sleep 5
    # Wait for Flatseal to close
    echo "Waiting for Flatseal to close..."
    wait # Wait for the background process to finish
    echo "Flatseal has closed."
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
    1) setup_flatpak ;;                            # Install or uninstall flatpak system in a distro
    2) list_all_apps ;;                            # List apps
    3) list_user_apps ;;                           # List user apps
    4) update_apps ;;                              # Update all apps
    5) install_app ;;                              # Search and install app
    6) uninstall_app ;;                            # Uninstall app
    7) downgrade_app ;;                            # Downgrade app
    8) delete_unused ;;                            # Delete unused runtime and flatpak cache
    9) manage_permissions ;;                       # Manage permissions for Flatpak apps using Flatseal
    10) main_menu ;;                               # Exit to main menu
    *) echo "Invalid choice. Please try again." ;; # Invalid choice
    esac
done
