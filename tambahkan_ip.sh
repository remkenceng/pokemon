#!/bin/bash

if ! command -v gh &> /dev/null; then
    echo "gh tidak terinstall, menginstall..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
      && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
      && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
      && sudo apt update \
      && sudo apt install gh -y
fi

if ! gh auth status > /dev/null 2>&1; then
    gh auth login
fi

TEMP_DIR=$(mktemp -d -t pokemon-XXXX)
git clone --progress --verbose https://github.com/remkenceng/pokemon.git "$TEMP_DIR" > /dev/null 2>&1
cd "$TEMP_DIR" || exit

while true; do
    read -p "Username : " username
    read -p "Ip : " ip
    read -p "Expired : " expired
    
    # Check if IP already exists in the file
    if grep -q "| $ip |" izin/ip; then
        existing_entry=$(grep "| $ip |" izin/ip)
        tput reset
        echo "Ip Ini Sudah Digunakan Oleh User Ini !"
        echo ""
        echo "$existing_entry"
        echo ""
        read -p "Press [Enter] : "
        continue
    fi
    
    echo ""
    echo "$username | $ip | $expired" >> izin/ip
    git add izin/ip
    git commit -m "Menambahkan $username Dengan Ip $ip"
    echo ""
    git push
    echo ""
    rm -rf "$TEMP_DIR"
    break
done

cd .. || exit
