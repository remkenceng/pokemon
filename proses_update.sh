#!/bin/bash

tput reset

proses_membersihkan() {
    rm -rf /usr/local/sbin/* 2>/dev/null
}

proses_unduh() {
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
    
    cd "$DIR" || { echo "Failed to change to $DIR"; exit 1; }

    for FILE in "${FILES[@]}"; do
        echo "Downloading $file..."
        wget -q --show-progress "$REPO_URL$file" -O "$FILE"
        chmod +x "$FILE" 2>/dev/null
    done
}

proses_membersihkan
proses_unduh
tput reset
read -n 1 -s -r -p "Tekan [ Enter ] Untuk Kembali : "
menu