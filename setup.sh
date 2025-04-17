#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

CLONE_DIR="$HOME/hypr-dots"
CONFIG_DIR="$HOME/.config/hypr"

# Ask user to make a backup of the current hyprland config if it exists
if [ -d "$CONFIG_DIR" ]; then
    echo -e "${GREEN}Found existing config directory for Hyprland... Do you want to perform a backup? (y/n)${NC}"
    read -r VAR

    case "$VAR" in
    [yY][eE][sS] | [yY]) # Accept 'y', 'Y', 'yes', or 'Yes'
        echo -e "${GREEN}🔧 Backing up $CONFIG_DIR to $CONFIG_DIR.bak...${NC}"
        mv "$CONFIG_DIR" "$CONFIG_DIR".bak
        if [ -d "$CONFIG_DIR".bak ]; then
            echo -e "${GREEN}✅ Successfully backed up config${NC}"
            # After backing up the dir you have to Create a new one
            mkdir -p "$CONFIG_DIR" \
                "$CONFIG_DIR/mako" \
                "$CONFIG_DIR/scripts" \
                "$CONFIG_DIR/waybar" \
                "$CONFIG_DIR/wofi" \
                "$CONFIG_DIR/wofifull"
        else
            echo -e "${RED}⚠️ Couldn't backup the folder! Exiting...${NC}"
            exit 1
        fi
        ;;
    [nN][oO] | [nN]) # Accept 'n', 'N', 'no', or 'No'
        echo -e "${RED}🚫 Skipping backup...${NC}"
        ;;
    *) # Default case (any invalid input)
        echo -e "${RED}⚠️ Invalid input. Skipping backup.${NC}"
        ;;
    esac
else
    # Create the directory if it doesn't exist
    echo -e "${GREEN}No existing config found. Creating necessary directories...${NC}"
    mkdir -p "$CONFIG_DIR" \
        "$CONFIG_DIR/mako" \
        "$CONFIG_DIR/scripts" \
        "$CONFIG_DIR/waybar" \
        "$CONFIG_DIR/wofi" \
        "$CONFIG_DIR/wofifull"
fi

# Now, copy the needed files from the cloned repo
echo -e "${GREEN}📂 Copying config files from $CLONE_DIR to $CONFIG_DIR...${NC}"

# Copy all relevant files and directories from the cloned repository to the config directory
cp "$CLONE_DIR"/hyprland.conf "$CONFIG_DIR/"
cp -r "$CLONE_DIR"/mako/* "$CONFIG_DIR/mako/"
cp -r "$CLONE_DIR"/waybar/* "$CONFIG_DIR/waybar/"
cp -r "$CLONE_DIR"/wofi/* "$CONFIG_DIR/wofi/"
cp -r "$CLONE_DIR"/wofifull/* "$CONFIG_DIR/wofifull/"
cp -r "$CLONE_DIR"/scripts/* "$CONFIG_DIR/scripts/"

# Check if the files were copied successfully
if [ -d "$CONFIG_DIR" ]; then
    echo -e "${GREEN}✅ Successfully copied config files!${NC}"
else
    echo -e "${RED}⚠️ There was an error copying the config files. Exiting...${NC}"
    exit 1
fi

echo -e "${GREEN}🔧 Setup complete! You can now proceed with further configuration if necessary.${NC}"
