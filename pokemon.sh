#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

CEK_IP=$(curl -sS ipv4.icanhazip.com)
REPO_IZIN_IP=$(curl -sS https://raw.githubusercontent.com/remkenceng/pokemon/main/izin/ip)

memeriksa_ip() {
    IP_VALID=$(echo "$REPO_IZIN_IP" | awk '{print $3}')
    if [[ "$CEK_IP" != "$IP_VALID" ]]; then
        menampilkan_pesan_error
    fi
}

memeriksa_member() {
    IP_VALID=$(echo "$REPO_IZIN_IP" | awk '{print $3}')
    echo -e "${CYAN}"
    echo -e "${WHITE}► Ip         : ${GREEN}$CEK_IP${NC}"
    if [[ "$CEK_IP" == "$IP_VALID" ]]; then
        echo -e "${WHITE}► Status     : ${GREEN}Ip Terdaftar${NC}"
    else
        echo -e "${WHITE}► Status     : ${RED}Ip Tidak Terdaftar${NC}"
    fi
}

menampilkan_header() {
    clear
    echo -e "${PURPLE}"
    echo -e "██████╗  ██████╗ ██╗  ██╗███████╗███╗   ███╗ ██████╗ ███╗   ██╗"
    echo -e "██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝████╗ ████║██╔═══██╗████╗  ██║"
    echo -e "██████╔╝██║   ██║█████╔╝ █████╗  ██╔████╔██║██║   ██║██╔██╗ ██║"
    echo -e "██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║"
    echo -e "██║     ╚██████╔╝██║  ██╗███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║"
    echo -e "╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

menampilkan_menu() {
    memeriksa_member
    echo -e "${PURPLE}"
    echo -e "${GREEN} 1.${WHITE} Install Pokemon Tunneling ${YELLOW}[Paid]${NC}"
    echo -e "${GREEN} 2.${WHITE} Update Pokemon Tunneling ${YELLOW}[Paid]${NC}"
    echo -e "${GREEN} 3.${WHITE} Update Dependencies ${YELLOW}[Free]${NC}"
    echo -e "${GREEN} 4.${WHITE} Reset Root Password ${YELLOW}[Free]${NC}"
    echo -e "${GREEN} 5.${WHITE} Exit${NC}"
    echo ""
    read -p "$(echo -e "${YELLOW}Pilih Pilihanmu [1-5]: ${NC}")" Input
    echo ""
}

menampilkan_pesan_error() {
    menampilkan_header
    IP_VALID=$(echo "$REPO_IZIN_IP" | awk '{print $3}')
    echo -e "${CYAN}"
    echo -e "${WHITE}► Ip         : ${GREEN}$CEK_IP${NC}"
    if [[ "$CEK_IP" == "$IP_VALID" ]]; then
        echo -e "${WHITE}► Status     : ${GREEN}Ip Terdaftar${NC}"
    else
        echo -e "${WHITE}► Status     : ${RED}Ip Tidak Terdaftar${NC}"
    fi
    echo ""
    echo -e "${CYAN}Hubungi WhatsApp : ${GREEN}https://wa.me/6282124807605${NC}"
    echo -e "${CYAN}Hubungi Telegram : ${GREEN}@RemKenceng${NC}"
    echo ""
    read -n 1 -s -r -p "$(echo -e "${YELLOW}Press [Enter] : ${NC}")"
    bash pokemon.sh
}

reset
menampilkan_header
menampilkan_menu

case $Input in
    1)
        memeriksa_ip
        menampilkan_header
        wget -q https://raw.githubusercontent.com/remkenceng/pokemon/main/install.sh
        chmod +x install.sh
        bash install.sh
        rm -rf install.sh
        ;;
    2)
        memeriksa_ip
        menampilkan_header
        wget -q https://raw.githubusercontent.com/remkenceng/pokemon/main/proses_update.sh
        chmod +x proses_update.sh
        bash proses_update.sh
        rm -rf proses_update.sh
        ;;
    3)
        menampilkan_header
        sudo apt-get update -y && sudo apt-get upgrade -y
        sleep 2
        bash pokemon.sh
        ;;
    4)
        menampilkan_header
        wget -q https://raw.githubusercontent.com/remkenceng/pokemon/main/root/install.sh
        chmod +x install.sh
        bash install.sh
        ;;
    5)
        menampilkan_header
        reset
        exit 0
        ;;
    *)
        menampilkan_header
        echo "" 
        memeriksa_member
        echo ""
        echo -e "${YELLOW}Pilihanmu Tidak Tersedia ..... !${NC}"
        echo ""
        read -n 1 -s -r -p "$(echo -e "${YELLOW}Press [Enter] : ${NC}")"
        bash pokemon.sh
        ;;
esac