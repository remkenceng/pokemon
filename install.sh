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

REPO_POKEMON="https://raw.githubusercontent.com/remkenceng/pokemon/main"
REPO_IZIN_IP="https://raw.githubusercontent.com/remkenceng/pokemon/main/izin/ip"
IP_CHECK_API="https://api.ipify.org"

IP_ADDRESS=""
EXPIRY_DATE=""
LEFT_DAYS=""

convert_date_format() {
    local input_date="$1"
    echo "$input_date" | awk -F'-' '{print $3"-"$2"-"$1}'
}

log() {
    echo "[$(date '+%d-%m-%Y %H:%M:%S')] $1"
}

cleanup() {
    if [ -f "/tmp/pokemon/proses_install.sh" ]; then
        rm -f "/tmp/pokemon/proses_install.sh"
    fi
    echo ""
}

calculate_days_left() {
    if [ "$EXPIRY_DATE" == "Unlimited" ] || [ -z "$EXPIRY_DATE" ]; then
        LEFT_DAYS="Unlimited"
        return
    fi
    
    today=$(date +"%d-%m-%Y")
    
    expiry_sec=$(date -d "$(convert_date_format "$EXPIRY_DATE")" +%s 2>/dev/null)
    today_sec=$(date -d "$(convert_date_format "$today")" +%s 2>/dev/null)
    
    if [ -z "$expiry_sec" ] || [ -z "$today_sec" ]; then
        LEFT_DAYS="Invalid Date"
        log "Error: Date conversion failed - Expiry: $EXPIRY_DATE, Today: $today"
        return
    fi
    
    seconds_left=$((expiry_sec - today_sec))
    
    if [ $seconds_left -lt 0 ]; then
        LEFT_DAYS="Expired"
    else
        LEFT_DAYS=$(( (seconds_left + 86399) / 86400 ))
    fi
}

show_header() {
    clear
    echo -e "${YELLOW}=============================================${NC}"
    echo -e "        ${green}POKEMON TUNNELING INSTALLER ${NC}        "
    echo -e "${YELLOW}=============================================${NC}"
    echo ""
}

check_internet() {
    if ! curl -Is "$IP_CHECK_API" >/dev/null; then
        log "Error: No internet connection or server unreachable"
        echo -e "${ERROR} No internet connection or server unreachable"
        exit 1
    fi
}

check_ip() {
    IP_ADDRESS=$(curl -s "$IP_CHECK_API")
    
    if [ -z "$IP_ADDRESS" ]; then
        log "Error: IP address not found!"
        echo -e "${ERROR} IP address not found!"
        exit 1
    fi
    
    IP_WHITELIST=$(curl -s "$REPO_IZIN_IP")
    if [ -z "$IP_WHITELIST" ]; then
        log "Error: License data not found!"
        echo -e "${ERROR} License data not found!"
        exit 1
    fi
    
    IP_DATA=$(echo "$IP_WHITELIST" | grep -w "$IP_ADDRESS")
    if [ -n "$IP_DATA" ]; then
        EXPIRY_DATE=$(echo "$IP_DATA" | awk '{print $5}')
        if [ -z "$EXPIRY_DATE" ]; then
            EXPIRY_DATE="Unlimited"
        fi
        calculate_days_left
        return 0
    else
        return 1
    fi
}

check_subscription() {
    if [ "$LEFT_DAYS" == "Expired" ]; then
        show_header
        echo -e "${RED}Periode Berlangganan Kamu Sudah Habis !${NC}"
        echo ""
        echo -e "${green}Hubungi WhatsApp : https://wa.me/6282124807605${NC}"
        echo -e "${green}Hubungi Telegram : @RemKenceng${NC}"
        exit 1
    fi
}

run_installation() {
    rm -rf /tmp/pokemon/*
    mkdir -p /tmp/pokemon
    
    if ! curl -s -o "/tmp/pokemon/proses_install.sh" "$REPO_POKEMON/proses_install.sh"; then
        log "Error: Failed to download installation script!"
        echo -e "${ERROR} Failed to download installation script!"
        exit 1
    fi
    
    chmod +x "/tmp/pokemon/proses_install.sh"
    if ! bash "/tmp/pokemon/proses_install.sh" 2>&1 | tee -a /tmp/pokemon_install.log; then
        log "Error: Installation failed!"
        echo -e "${ERROR} Installation failed!"
        exit 1
    fi
}

show_denied() {
    show_header
    echo -e "Ip ${purple}[$IP_ADDRESS]${NC}${red} -> Belum Berlangganan ?${NC}"
    echo ""
    echo -e "${green}Hubungi WhatsApp : https://wa.me/6282124807605${NC}"
    echo -e "${green}Hubungi Telegram : @RemKenceng${NC}"
    exit 1
}

show_menu() {
    echo ""
    echo "1. Install Script"
    echo "2. Update Script" 
    echo "3. Quit Script"
    echo ""
    echo -n "Choose Options : "
    read -r choice
    
    case $choice in
        1)
            run_installation
            ;;
        2)
            echo -e "${green}Script updated successfully!${NC}"
            sleep 1
            ;;
        3)
            exit 0
            ;;
        *)
            echo -e "${red}Invalid option!${NC}"
            sleep 1
            show_menu
            ;;
    esac
}

trap cleanup EXIT
show_header
check_internet

if check_ip; then
    check_subscription
    longest_label=$(printf "Ip\nSubscription\nDays Remaining" | awk '{ print length() }' | sort -nr | head -1)
    show_header
    printf "%-${longest_label}s : ${purple}%s${NC}\n" "Ip" "$IP_ADDRESS"
    printf "%-${longest_label}s : ${purple}%s${NC}\n" "Subscription" "$EXPIRY_DATE"
    printf "%-${longest_label}s : ${purple}%s${NC}\n" "Days Remaining" "$LEFT_DAYS"
    show_menu
else
    show_denied
fi