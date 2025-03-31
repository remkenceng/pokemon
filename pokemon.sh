#!/bin/bash

reset

echo "1. Install Pokemon Tunneling"
echo "2. Update Dependency"
echo "3. Get Root"
echo "4. Exit"
echo ""
read -p "Pilih : " Input
echo ""

case $Input in
    1)
        wget https://raw.githubusercontent.com/remkenceng/pokemon/main/install.sh
        chmod +x install.sh
        reset
        bash install.sh
        ;;
    2)
        sudo apt-get update -y && sudo apt-get upgrade -y
        ;;
    3)
        wget https://raw.githubusercontent.com/remkenceng/pokemon/main/root/install.sh
        chmod +x install.sh
        bash install.sh
        ;;
    4)
        exit
        ;;
    *)
        echo "Wrong Input Brok ..... !"
        sleep 2
        reset
        bash pokemon.sh
        ;;
esac