#!/bin/bash

if ! gh auth status > /dev/null 2>&1; then
    gh auth login
fi

TEMP_DIR=$(mktemp -d -t pokemon-XXXX)
git clone --progress --verbose https://github.com/remkenceng/pokemon.git "$TEMP_DIR" > /dev/null 2>&1
cd "$TEMP_DIR" || exit

while true; do
    tput reset
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