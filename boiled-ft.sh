#!/bin/bash

rainbow_logo() {
    RAW_URL="https://pastebin.com/raw/dRVtFUD6"

    if command -v curl >/dev/null 2>&1; then
        ASCII_ART=$(curl -s "$RAW_URL")
    elif command -v wget >/dev/null 2>&1; then
        ASCII_ART=$(wget -qO- "$RAW_URL")
    else
        echo "Cannot fetch logo. Please install curl or wget."
        return
    fi

    # Rainbow Colors (line by line)
    COLORS=(31 33 32 36 34 35) # red, yellow, green, cyan, blue, magenta
    i=0
    while IFS= read -r line; do
        color=${COLORS[i]}
        echo -e "\e[${color}m${line}\e[0m"
        i=$(( (i+1) % ${#COLORS[@]} ))
    done <<< "$ASCII_ART"
}

# Display rainbow logo
rainbow_logo
echo
echo "Starting BOILED Installation..."
sleep 1

# Clone repository
git clone https://github.com/EshanGemuk5447/boiled-repository ~/boiled-repository

# Move Binary
sudo mv ~/boiled-repository/boil /usr/local/bin/
sudo chmod +x /usr/local/bin/boil

# Unzip boiled.zip
sudo unzip ~/boiled-repository/boiled.zip -d ~/boiled-repository

# Move boiled file
sudo mv ~/boiled-repository/boiled /

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")

case "$CURRENT_SHELL" in
    bash)
        RC_FILE="$HOME/.bashrc"
        ;;
    zsh)
        RC_FILE="$HOME/.zshrc"
        ;;
    *)
        echo "Unsupported shell: $CURRENT_SHELL"
        exit 1
        ;;
esac

# Append the line safely
echo "export boiled=/boiled" >> "$RC_FILE"

# Source the active shell rc file
source "$RC_FILE"

echo "Added 'export boiled=/boiled' to $RC_FILE and sourced it!"

# Remove the cloned repository
sudo rm -rf ~/boiled-repository

# Print finish message in red
echo -e "\e[31mFINISH INSTALLATION\e[0m"
echo "IF the word '/boiled' showed up after ':' then it works: $(echo $boiled)"
echo "If no word '/boiled' after ':', pls add line export boiled='/boiled' at the end of your shell (example: ~/.zshrc, ~/.bashrc, etc.)
