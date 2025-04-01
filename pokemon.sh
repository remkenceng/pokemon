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
REPO_POKEMON="https://raw.githubusercontent.com/remkenceng/pokemon/main"
REPO_IZIN_IP=$(curl -sS https://raw.githubusercontent.com/remkenceng/pokemon/main/izin/ip)

hitung_durasi() {
    local exp_date="$1"
    local day=$(echo "$exp_date" | cut -d'-' -f1)
    local month=$(echo "$exp_date" | cut -d'-' -f2)
    local year=$(echo "$exp_date" | cut -d'-' -f3)
    local exp_date_std="$year-$month-$day"
    
    local today=$(date +%Y-%m-%d)
    local exp_seconds=$(date -d "$exp_date_std" +%s 2>/dev/null)
    local today_seconds=$(date -d "$today" +%s)
    
    if [ -z "$exp_seconds" ]; then
        echo "invalid"
        return
    fi
    
    local diff=$(( (exp_seconds - today_seconds) / 86400 ))
    
    if [ "$diff" -lt 0 ]; then
        echo "0"
    else
        echo "$diff"
    fi
}

memeriksa_ip() {
    while IFS= read -r line; do
        ip_in_file=$(echo "$line" | awk '{print $3}')
        if [ "$ip_in_file" == "$CEK_IP" ]; then
            return 0
        fi
    done <<< "$REPO_IZIN_IP"
    
    menampilkan_pesan_error
    return 1
}

memeriksa_member() {
    echo -e "${CYAN}"
    echo -e "${WHITE}► Ip         : ${YELLOW}$CEK_IP${NC}"
    
    while IFS= read -r line; do
        ip_in_file=$(echo "$line" | awk '{print $3}')
        if [ "$ip_in_file" == "$CEK_IP" ]; then
            USERNAME_VALID=$(echo "$line" | awk '{print $1}')
            EXP_DATE=$(echo "$line" | awk '{print $5}')
            DURATION=$(hitung_durasi "$EXP_DATE")
            
            echo -e "${WHITE}► Status     : ${GREEN}Ip Terdaftar${NC}"
            echo -e "${WHITE}► Username   : ${PURPLE}$USERNAME_VALID${NC}"
            
            if [ "$DURATION" == "invalid" ]; then
                echo -e "${WHITE}► Exp Date   : ${RED}Invalid Date Format (DD-MM-YYYY)${NC}"
            elif [ "$DURATION" -le 0 ]; then
                echo -e "${WHITE}► Duration   : ${RED}Expired Semenjak ${EXP_DATE}${NC}"
            else
                echo -e "${WHITE}► Duration   : ${GREEN}$DURATION Hari Sampai ${EXP_DATE}${NC}"
            fi
            
            return 0
        fi
    done <<< "$REPO_IZIN_IP"
    
    menampilkan_header
    echo -e "${WHITE}► Ip         : ${YELLOW}$CEK_IP${NC}"
    echo -e "${WHITE}► Status     : ${RED}Ip Tidak Terdaftar${NC}"
    echo ""
    echo -e "${CYAN}Hubungi WhatsApp : ${GREEN}https://wa.me/6282124807605${NC}"
    echo -e "${CYAN}Hubungi Telegram : ${GREEN}@RemKenceng${NC}"
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
    echo -e "${GREEN}  1.${WHITE} Install Pokemon Tunneling ${YELLOW}[Paid]${NC}"
    echo -e "${GREEN}  2.${WHITE} Update Pokemon Tunneling ${YELLOW}[Paid]${NC}"
    echo -e "${GREEN}  3.${WHITE} Update Dependencies ${YELLOW}[Free]${NC}"
    echo -e "${GREEN}  4.${WHITE} Reset Root Password ${YELLOW}[Free]${NC}"
    echo -e "${GREEN}  5.${WHITE} Exit${NC}"
    echo ""
    read -p "$(echo -e "${YELLOW}Pilih Pilihanmu [1-5]: ${NC}")" Input
    echo ""
}

menampilkan_pesan_error() {
    menampilkan_header
    echo -e "${WHITE}► Ip         : ${YELLOW}$CEK_IP${NC}"
    echo -e "${WHITE}► Status     : ${RED}Ip Tidak Terdaftar${NC}"
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
        rm -rf /tmp/pokemon/*
        mkdir -p /tmp/pokemon
        wget -q -O /tmp/pokemon/proses_install.sh "$REPO_POKEMON/proses_install.sh"
        chmod +x /tmp/pokemon/proses_install.sh
        bash /tmp/pokemon/proses_install.sh
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
        memeriksa_member
        echo -e "${YELLOW}Pilihanmu Tidak Tersedia ..... !${NC}"
        echo ""
        read -n 1 -s -r -p "$(echo -e "${YELLOW}Press [Enter] : ${NC}")"
        bash pokemon.sh
        ;;
esac