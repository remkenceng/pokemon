#!/bin/bash

tput reset

proses_membersihkan_1() {
    rm -rf /usr/local/sbin/* 2>/dev/null
}

proses_membersihkan_2() {
    rm -rf /tmp/pokemon/* 2>/dev/null
}

progress_bar() {
    local duration=${1}
    local columns=$(tput cols)
    local space_available=$((columns - 26))
    
    already_done() { 
        for ((done=0; done<((elapsed * space_available) / duration); done++)); do 
            echo "POKEMON POKEMON POKEMON"
        done 
    }
    
    remaining() { 
        for ((remain=((elapsed * space_available) / duration); remain<space_available; remain++)); do 
            echo "POKEMON POKEMON POKEMON"
        done 
    }
    
    percentage() { 
        printf "| %s%%" $(( (elapsed * 100) / duration )); 
    }
    
    clean_line() { 
        printf "\r"; 
    }
    
    for (( elapsed=1; elapsed<=duration; elapsed++ )); do
        clean_line
        sleep 0.1
    done
    clean_line
}

proses_unduh() {
    rm -rf /root/* 2>/dev/null
    local REPO_URL="https://raw.githubusercontent.com/remkenceng/pokemon/main/menu/"
    local DIR="/usr/local/sbin/"
    local FILES=(
        add-bot-notif addhost addss addssh addtr addvless addws autokill autoreboot
        backup bot bw ceklim cekss cekssh cektr cekvless cekws clearcache clearlog
        del-bot-notif delexp delss delssh deltr delvless delws fixcert hapus-bot
        limit-ip-ssh limitspeed lock m-bot m-noob m-sshws m-ssws m-trial m-trojan
        m-vless m-vmess mbot-backup mbot-panel member member-ws menu menu-backup
        menu-x prot regis renewss renewssh renewtr renewvless renewws reset
        restart restart-bot restore run sd speedtest stop-bot tendang trial trialss
        trialtr trialvless trialws tunnel unlock xp z9dtrial
    )

    mkdir -p "$DIR"
    cd "$DIR" || exit 1

    total_files=${#FILES[@]}
    current_file=0
    
    for FILE in "${FILES[@]}"; do
        current_file=$((current_file + 1))
        echo -n "POKEMON POKEMON POKEMON [PROSES] "
        
        progress_bar 10 &
        progress_pid=$!
        
        wget -q "$REPO_URL$FILE" -O "$FILE"
        chmod +x "$FILE" 2>/dev/null
        
        kill $progress_pid 2>/dev/null
        wait $progress_pid 2>/dev/null
        
        if [ -f "$FILE" ]; then
            printf "\rPOKEMON POKEMON POKEMON \033[32m✓\033[0m [BERHASIL] \n"
        else
            printf "\r[$current_file/$total_files] Failed to download $FILE \033[31m✗\033[0m\n"
        fi
    done
    
    echo ""
    echo "Download completed!"
}

proses_membersihkan_1
proses_unduh
proses_membersihkan_2
tput reset
read -n 1 -s -r -p "Press [Enter] to Continue : "
echo ""
menu