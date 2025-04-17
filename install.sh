#!/bin/bash

set -e # Exit immediately on error
clear

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

REPO_URL="https://github.com/TH-O-R/hypr-dots.git"
CLONE_DIR="$HOME/hypr-dots"
REQUIREMENTS_FILE="$CLONE_DIR/requirements.txt"

echo -e "${RED}
     ┬  ┬┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐
     ├──┤└┬┘├─┘├┬┘│  ├─┤│││ ││ - TH-O-R
     ┴  ┴ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘
${NC}"

# First, ensure the script isn't running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED} Do not run the script as root (SUDO)! Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}🌿 Starting Hypr-Dots installation...${NC}\n"

echo -e "${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}"
echo -e "${RED} ATTENTION: Run a full system update and reboot first (Highly Recommended).${NC}"
echo -e "${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}\n\n"
echo -e "Beginning in 5 seconds..."
sleep 5

# Step 1: Install essential packages if not present
echo -e "Proceeding to install Important packages..."
sudo pacman -S base-devel --needed
if ! command -v git &>/dev/null; then
    echo -e "${GREEN}📦 git not found. Installing git...${NC}"
    sudo pacman -S git
else
    echo -e "${GREEN}{::}${NC} git is already installed. Proceeding"
fi
if ! command -v yay &>/dev/null; then
    echo -e "${GREEN}📦 yay not found. Installing yay...${NC}"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo -e "${GREEN}{::}${NC} yay is already installed."
fi

# Step 2: Clone hypr-dots repo if it doesn't exist
if [ ! -d "$CLONE_DIR" ]; then
    echo -e "${GREEN}📁 Cloning repo into $CLONE_DIR...${NC}"
    git clone "$REPO_URL" "$CLONE_DIR" --depth 1
else
    echo -e "${GREEN}{::}📁 Repo already exists at $CLONE_DIR. Pulling latest changes...${NC}"
    cd $CLONE_DIR
    git stash && git pull
fi

# Step 3: Install dependencies line by line (from requirements.txt)
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo -e "${GREEN}📦 Installing dependencies from $REQUIREMENTS_FILE...${NC}"

    # Install all dependencies in one go, skipping comments/empty lines
    yay -S --needed --noconfirm $(grep -vE '^\s*(#|$)' "$REQUIREMENTS_FILE")
else
    echo -e "${RED}⚠️ No $REQUIREMENTS_FILE found! Skipping dependency installation.${NC}"
fi

# Step 4: Optional setup script - Prompt the user
echo -e "${GREEN}{::}${NC}Do you want to run the automatic setup script (setup.sh)? [y/n]: "
read -r VAR

case "$VAR" in
[yY][eE][sS] | [yY]) # Accept 'y', 'Y', 'yes', or 'Yes'
    echo -e "${GREEN}🔧 Running setup.sh...${NC}"
    if [ -f "setup.sh" ]; then
        chmod +x setup.sh
        ./setup.sh
    else
        echo -e "${RED}⚠️ No setup.sh found in the repo! Skipping setup.${NC}"
    fi
    ;;
[nN][oO] | [nN]) # Accept 'n', 'N', 'no', or 'No'
    echo -e "${RED}🚫 Skipping automatic setup.${NC}"
    ;;
*) # Default case (any invalid input)
    echo -e "${RED}⚠️ Invalid input. Skipping automatic setup.${NC}"
    ;;
esac

echo -e "${GREEN}✅ Hypr-Dots installation complete!${NC}"
