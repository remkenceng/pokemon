#!/bin/bash

reset

CEK_IP=$(curl -sS ipv4.icanhazip.com)
REPO_IZIN_IP=$(curl -sS https://raw.githubusercontent.com/remkenceng/pokemon/main/izin/ip)

if ! awk -v ip="$CEK_IP" '$0 ~ ip' <<< "$REPO_IZIN_IP"; then
    echo "Kamu Belum Berlangganan !"
    exit 1
fi

echo "1. Install Pokemon Tunneling"
echo "2. Update Pokemon Tunneling"
echo "3. Update Dependency"
echo "4. Get Root"
echo "5. Exit"
echo ""
read -p "Pilih : " Input
echo ""

case $Input in
    1)
        wget https://raw.githubusercontent.com/remkenceng/pokemon/main/install.sh
        chmod +x install.sh
        reset
        bash install.sh
        rm -rf install.sh
        ;;
    2)
        wget https://raw.githubusercontent.com/remkenceng/pokemon/main/proses_update.sh
        chmod +x proses_update.sh
        reset
        bash proses_update.sh
        rm -rf proses_update.sh
        ;;
    3)
        sudo apt-get update -y && sudo apt-get upgrade -y
        bash pokemon.sh
        ;;
    4)
        wget https://raw.githubusercontent.com/remkenceng/pokemon/main/root/install.sh
        chmod +x install.sh
        bash install.sh
        ;;
    5)
        exit
        ;;
    *)
        echo "Wrong Input Brok ..... !"
        sleep 2
        reset
        bash pokemon.sh
        ;;
esac

