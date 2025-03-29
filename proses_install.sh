#!/bin/bash
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'
purple="\e[0;33m"

REPO="https://raw.githubusercontent.com/remkenceng/pokemon/main/"
IP_CHECK_API="https://api.ipify.org"
TIMEOUT=10
LOG_FILE="/tmp/pokemon_install.log"

log() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cleanup() {
    if [ -f "/tmp/pokemon/proses_install.sh" ]; then
        rm -f "/tmp/pokemon/proses_install.sh"
    fi
    echo ""
}

trap cleanup EXIT

show_header() {
    clear
    echo -e "${YELLOW}=============================================${NC}"
    echo -e "        ${green}POKEMON TUNNELING INSTALLER ${NC}        "
    echo -e "${YELLOW}=============================================${NC}"
    echo ""
}

check_internet() {
    if ! curl -Is "$IP_CHECK_API" --connect-timeout $TIMEOUT >/dev/null; then
        log "Error: Tidak ada koneksi internet atau server tidak dapat dijangkau"
        exit 1
    fi
}

check_ip() {
    IP_ADDRESS=$(curl -s --connect-timeout $TIMEOUT "$IP_CHECK_API")
    
    if [ -z "$IP_ADDRESS" ]; then
        log "Error: IP Tidak Dapat Ditemukan !"
        exit 1
    fi
    
    if ! IP_WHITELIST=$(curl -s --connect-timeout $TIMEOUT "${REPO}izin/ip"); then
        log "Error: Lisensi Tidak Dapat Ditemukan !"
        exit 1
    fi
    
    if grep -q "$IP_ADDRESS" <<< "$IP_WHITELIST"; then
        return 0
    else
        return 1
    fi
}

run_installation() {    
    rm -rf *
    mkdir -p /tmp/pokemon
    if ! curl -s --connect-timeout "$TIMEOUT" -o "/tmp/pokemon/proses_install.sh" "${REPO}proses_install.sh"; then
        log "Error: Tidak Berhasil Dilakukan Instalasi !"
        exit 1
    fi
    
    chmod +x "/tmp/pokemon/proses_install.sh"
    bash "/tmp/pokemon/proses_install.sh" 2>&1 | tee -a "$LOG_FILE"
    
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        log "Error: Proses Instalasi Gagal !"
        exit 1
    fi
}

show_denied() {
    show_header
    echo -e "Sorry, Ip ${purple}[$IP_ADDRESS]${NC} ${red}Belum Berlangganan${NC}"
    echo ""
    echo -e "${green}Hubungi WhatsApp: https://wa.me/6282124807605${NC}"
    echo -e "${green}Hubungi Telegram: @RemKenceng${NC}"

    exit 1
}

show_menu() {
    echo ""
    echo -e "${YELLOW}POKEMON INSTALLER CHOICE !${NC}"
    echo "1. Install Script"
    echo "2. Update Script"
    echo ""
    echo -n "Input Pilihan [1-3] : "
    read choice
    case $choice in
        1)
	    echo ""
            echo "Pemasangan Script Sedang Dijalankan ..... !"
            run_installation
            ;;
        2)
	    echo ""
	    echo -e "${green}Pembaharuan Script Berhasil Dilakukan ..... !${NC}"
            ;;
        *)
            echo ""
            echo ""
	    echo -e "${red}Inputan Kamu Tidak Dikenali !${NC}"
	    exit 1
            ;;
    esac
}

show_header
check_internet

if check_ip; then
    show_header
    echo -e "Thanks Ip ${purple}[$IP_ADDRESS]${NC} ${green}Sudah Berlangganan${NC}"
    sleep 2
    show_menu
else
    show_denied
fi
