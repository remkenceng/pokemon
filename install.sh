#!/bin/bash

# Color Definitions
GREEN="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
NC='\e[0m'
PURPLE="\e[0;33m"

# Configuration
REPO_POKEMON="https://raw.githubusercontent.com/remkenceng/pokemon/main"
REPO_IZIN_IP="https://raw.githubusercontent.com/remkenceng/pokemon/main/izin/ip"
IP_CHECK_API="https://api.ipify.org"

# Global Variables
IP_ADDRESS=""
EXPIRY_DATE=""
LEFT_DAYS=""

convert_date_format() {
    local input_date="$1"
    echo "$input_date" | awk -F'-' '{print $3"-"$2"-"$1}'
}

show_header() {
    clear
    echo -e "${YELLOW}=============================================${NC}"
    echo -e "        ${GREEN}POKEMON TUNNELING INSTALLER ${NC}        "
    echo -e "${YELLOW}=============================================${NC}"
    echo ""
}

check_internet() {
    if ! curl -Is "$IP_CHECK_API" >/dev/null; then
        echo -e "${RED}[ERROR] No internet connection or server unreachable${NC}"
        exit 1
    fi
}

check_ip() {
    IP_ADDRESS=$(curl -s "$IP_CHECK_API")
    [ -z "$IP_ADDRESS" ] && {
        echo -e "${RED}[ERROR] IP address not found!${NC}"
        exit 1
    }

    IP_WHITELIST=$(curl -s "$REPO_IZIN_IP")
    [ -z "$IP_WHITELIST" ] && {
        echo -e "${RED}[ERROR] License data not found!${NC}"
        exit 1
    }

    IP_DATA=$(echo "$IP_WHITELIST" | grep -w "$IP_ADDRESS")
    if [ -n "$IP_DATA" ]; then
        EXPIRY_DATE=$(echo "$IP_DATA" | awk '{print $5}')
        [ -z "$EXPIRY_DATE" ] && EXPIRY_DATE="Unlimited"
        calculate_days_left
        return 0
    fi
    return 1
}

calculate_days_left() {
    [ "$EXPIRY_DATE" == "Unlimited" ] && {
        LEFT_DAYS="Unlimited"
        return
    }
    
    today=$(date +"%d-%m-%Y")
    expiry_sec=$(date -d "$(convert_date_format "$EXPIRY_DATE")" +%s 2>/dev/null)
    today_sec=$(date -d "$(convert_date_format "$today")" +%s 2>/dev/null)
    
    [ -z "$expiry_sec" ] || [ -z "$today_sec" ] && {
        LEFT_DAYS="Invalid Date"
        return
    }
    
    seconds_left=$((expiry_sec - today_sec))
    [ $seconds_left -lt 0 ] && LEFT_DAYS="Expired" || LEFT_DAYS=$(( (seconds_left + 86399) / 86400 ))
}

check_subscription() {
    [ "$LEFT_DAYS" == "Expired" ] && {
        show_header
        echo -e "${RED}Periode Berlangganan Kamu Sudah Habis !${NC}"
        echo ""
        echo -e "${GREEN}Hubungi WhatsApp : https://wa.me/6282124807605${NC}"
        echo -e "${GREEN}Hubungi Telegram : @RemKenceng${NC}"
        exit 1
    }
}

run_installation() {
    wget -q -O /tmp/pokemon/proses_install.sh "$REPO_POKEMON/proses_install.sh"
    chmod +x /tmp/pokemon/proses_install.sh
    bash /tmp/pokemon/proses_install.sh
    rm -rf /tmp/pokemon
    exit
}

show_denied() {
    show_header
    echo -e "Ip ${PURPLE}[$IP_ADDRESS]${NC}${RED} -> Belum Berlangganan ?${NC}"
    echo ""
    echo -e "${GREEN}Hubungi WhatsApp : https://wa.me/6282124807605${NC}"
    echo -e "${GREEN}Hubungi Telegram : @RemKenceng${NC}"
    exit 1
}

show_menu() {
    echo ""
    echo "1. Install Script"
    echo "2. Update Script" 
    echo "3. Keluar"
    echo ""
    echo -n "Pilih Opsi : "
    read -r choice
    
    case $choice in
        1) run_installation ;;
        2) update_script ;;
        3) exit 0 ;;
        *) 
            echo -e "${RED}Pilihan Tidak Tersedia !${NC}"
            sleep 1
            show_menu
            ;;
    esac
}

# Main Execution
show_header
check_internet

if check_ip; then
    check_subscription
    longest_label=$(printf "Ip\nSubscription\nDays Remaining" | awk '{ print length() }' | sort -nr | head -1)
    show_header
    printf "%-${longest_label}s : ${PURPLE}%s${NC}\n" "Ip" "$IP_ADDRESS"
    printf "%-${longest_label}s : ${PURPLE}%s${NC}\n" "Subscription" "$EXPIRY_DATE"
    printf "%-${longest_label}s : ${PURPLE}%s${NC}\n" "Days Remaining" "$LEFT_DAYS"
    show_menu
else
    show_denied
fi