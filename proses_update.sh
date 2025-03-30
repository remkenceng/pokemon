#!/bin/bash

tput reset

proses_membersihkan() {
    rm -rf /usr/local/sbin/* 2>/dev/null
}

proses_unduh() {
    local base_url="https://raw.githubusercontent.com/remkenceng/pokemon/main/menu/"
    local download_dir="/usr/local/sbin/"
    local nama_nama_filenya=(
        add-bot-notif addhost addss addssh addtr addvless addws autokill autoreboot
        backup bot bw ceklim cekss cekssh cektr cekvless cekws clearcache clearlog
        del-bot-notif delexp delss delssh deltr delvless delws fixcert hapus-bot
        limit-ip-ssh limitspeed lock m-bot m-noob m-sshws m-ssws m-trial m-trojan
        m-vless m-vmess mbot-backup mbot-panel member member-ws menu menu-backup
        menu-x prot regis renewss renewssh renewtr renewvless renewws reset
        restart restart-bot restore run sd speedtest stop-bot tendang trial trialss
        trialtr trialvless trialws tunnel unlock xp z9dtrial
    )

    mkdir -p "$download_dir"
    
    cd "$download_dir" || { echo "Failed to change to $download_dir"; exit 1; }

    for file in "${nama_nama_filenya[@]}"; do
        echo "Downloading $file..."
        wget -q --show-progress "$base_url$file" -O "$file"
        chmod +x "$file" 2>/dev/null
    done
}

proses_membersihkan
proses_unduh
tput reset
read -n 1 -s -r -p "Tekan [ Enter ] Untuk Kembali : "
menu