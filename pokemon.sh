#!/bin/bash

reset_screen() {
    reset
    echo -e "\033[1;32m============================================\033[0m"
    echo -e "\033[1;33m             Pokemon Tunneling             \033[0m"
    echo -e "\033[1;32m============================================\033[0m"
}

reset_screen

CEK_IP=$(curl -sS ipv4.icanhazip.com)
REPO_IZIN_IP=$(curl -sS https://raw.githubusercontent.com/remkenceng/pokemon/main/izin/ip)

error_msg() {
    reset_screen
    echo -e "\033[1;31mIp [$CEK_IP] Tidak Terdaftar Pada Database Pokemon\033[0m"
    echo ""
    echo -e "  \033[1;32m Contact WhatsApp :\033[0m https://wa.me/6282124807605"
    echo -e "  \033[1;32m Contact Telegram :\033[0m @RemKenceng"
    echo ""
    read -n 1 -s -r -p $'\033[1;37mPress [Enter] : \033[0m'
    bash pokemon.sh
}

cek_ip_ke_url() {
    IP_VALID=$(echo "$REPO_IZIN_IP" | awk '{print $3}')
    if [[ "$CEK_IP" != "$IP_VALID" ]]; then
        error_msg
    fi
}

cek_langganan() {
    IP_VALID=$(echo "$REPO_IZIN_IP" | awk '{print $3}')
    echo "Ip     : $CEK_IP" 
    if [[ "$CEK_IP" == "$IP_VALID" ]]; then
        echo "Status : Berlangganan"
    else
        echo "Status : Tidak Berlangganan"
    fi
}

show_menu() {
    cek_langganan
    echo ""
    echo -e "\033[1;35mPokemon Services :\033[0m"
    echo -e "  \033[1;32m1.  \033[1;36mInstall Pokemon Tunneling [Paid]\033[0m"
    echo -e "  \033[1;32m2.  \033[1;36mUpdate Pokemon Tunneling [Paid]\033[0m"
    echo -e "  \033[1;32m3.  \033[1;36mUpdate Dependencies [Free]\033[0m"
    echo -e "  \033[1;32m4.  \033[1;36mReset Root Password [Free]\033[0m"
    echo -e "  \033[1;31m5.  Exit\033[0m"
    echo ""
    read -p $'\033[1;35mPilih Services [1-5] : \033[0m' Input
    echo ""
}

show_menu

case $Input in
    1)
        cek_ip_ke_url
        reset_screen
        wget -q https://raw.githubusercontent.com/remkenceng/pokemon/main/install.sh
        chmod +x install.sh
        bash install.sh
        rm -rf install.sh
        ;;
    2)
        cek_ip_ke_url
        reset_screen
        wget -q https://raw.githubusercontent.com/remkenceng/pokemon/main/proses_update.sh
        chmod +x proses_update.sh
        bash proses_update.sh
        rm -rf proses_update.sh
        ;;
    3)
        reset_screen
        sudo apt-get update -y && sudo apt-get upgrade -y
        sleep 2
        bash pokemon.sh
        ;;
    4)
        reset_screen
        wget -q https://raw.githubusercontent.com/remkenceng/pokemon/main/root/install.sh
        chmod +x install.sh
        bash install.sh
        ;;
    5)
        reset_screen
        echo -e "\033[1;35mThank you for using Pokemon Tunneling!\033[0m"
        exit 0
        ;;
    *)
        reset_screen
        echo -e "\033[1;31mInputan Tidak Sesuai ..... !\033[0m"
        echo ""
        read -n 1 -s -r -p "Press [Enter] : "
        bash pokemon.sh
        ;;
esac
