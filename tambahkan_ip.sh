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
    echo ""
    echo "$username | $ip | $expired" >> izin/ip
    git add izin/ip
    git commit -m "Menambahkan $username Dengan Ip $ip"
    echo ""
    git push
    echo ""
    break
done

rm -rf "$TEMP_DIR"
cd .. || exit